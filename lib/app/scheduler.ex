defmodule App.Scheduler do
  use GenServer

  @schedule_period_seconds 3600

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    schedule_work(1)
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    work()
    schedule_work(@schedule_period_seconds)
    {:noreply, state}
  end

  defp work do
    App.AwesomeFiller.fill_if_need()
  end

  defp schedule_work(seconds) do
    Process.send_after(self(), :work, seconds * 1000)
  end
end
