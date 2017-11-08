defmodule Postpool do
  @moduledoc """
  Documentation for Postpool.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Postpool.hello
      :world

  """
  def hello do
    IO.inspect {:hello, :here_we_go}

    {:ok, conn} = Postgrex.start_link(pool: DBConnection.Poolboy,
                                      name: :"#{__MODULE__}_Poolboy",
                                      pool_size: 8,
                                      database: "thomas")
    IO.inspect {:conn, conn}

    for identifier <- 1..10 do
      Task.async(fn -> query(conn, identifier) end)
    end

    IO.inspect {:hello, :success}
  end

  defp query(conn, identifier) do
    IO.inspect {:query, identifier, :in}
    case Postgrex.query(conn, "select pg_sleep(15)", [], pool: DBConnection.Poolboy) do
      {:ok, _} -> IO.inspect {:query, identifier, :out}
      _ -> IO.inspect {:query, identifier, :DIEDout}
    end
  end
end
