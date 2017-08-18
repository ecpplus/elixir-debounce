defmodule DBounce do
  @moduledoc """
  DBounce(https://www.npmjs.com/package/d-bounce) implementation in Elixir.

  ## Examples

      iex> require Logger
      Logger
      iex> DBounce.start_link
      {:ok, #PID<0.123.0>}
      iex> DBounce.bounce(:task1, fn -> Logger.debug("Hello") end, 5000)
      #PID<0.158.0>
      ~ after 5 seconds
      09:06:07.173 [debug] Hello
      iex> DBounce.bounce(:task1, fn -> Logger.debug("Hello") end, 5000)
      #PID<0.160.0>
      iex> DBounce.bounce(:task1, fn -> Logger.debug("World") end, 5000)
      #PID<0.162.0>
      ~ after 5 seconds
      09:06:46.517 [debug] World
      # Only executed once!
      # You can start with name
      iex> DBounce.start_link(:bouncer1)
      {:ok, #PID<0.165.0>}
      iex> DBounce.bounce(:bouncer1, :task2, fn -> Logger.debug("Hello") end, 5000)
      #PID<0.168.0>
      ~ after 5 seconds
      09:09:40.054 [debug] Hello
  """

  @doc false

  # @spec start_link(Atom.t) :: GenServer.on_start
  @spec start_link(Atom.t) :: GenServer.on_start
  def start_link(name) do
    Agent.start_link(fn -> Map.new end, name: name)
  end

  # @spec start_link() :: GenServer.on_start
  def start_link() do
    start_link(__MODULE__)
  end

  # @spec bounce(PID.t, any, Function.t, Integer.t)
  def bounce(pid, name, function, delay) do
    outer_self = self()

    Agent.get_and_update(
      pid,
      fn map ->
        case Map.get(map, name) do
          nil -> nil
          current_timer -> Process.cancel_timer(current_timer)
        end
        timer = Process.send_after(outer_self, nil, delay)
        {map, Map.put(map, name, timer)}
      end
    )

    receive do
      _ ->
        Agent.update(pid, fn map -> Map.delete(map, name) end)
        function.()
    end
  end

  # @spec bounce(Function.t, Atom.t, Integer.t)
  def bounce(name, function, delay) do
    bounce(__MODULE__, name, function, delay)
  end
end
