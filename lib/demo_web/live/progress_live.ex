defmodule DemoWeb.ProgressLive do
  @moduledoc false

  use DemoWeb, :live_view

  alias Demo.Examples.Cincy
  alias Demo.SystemData.{Memory, MemoryChart, VMEvents}
  alias Uncharted.{BaseChart, BaseDatum, Gradient}
  alias Uncharted.Axes.{BaseAxes, MagnitudeAxis, XYAxes}
  alias Uncharted.BarChart
  alias Uncharted.ColumnChart
  alias Uncharted.LineChart
  alias Uncharted.PieChart
  alias Uncharted.ProgressChart

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      VMEvents.subscribe()
    end

    colors = %{
      blue: "#6bdee4",
      rose_gradient: %Gradient{
        start_color: "#642B73",
        stop_color: "#C6426E"
      },
      blue_gradient: %Gradient{
        start_color: "#36D1DC",
        stop_color: "#5B86E5"
      },
      red_gradient: %Gradient{
        start_color: "#FF9486",
        stop_color: "#FF1379"
      }
    }

    column_chart = %BaseChart{
      title: "Cheese Coney Consumption by Neighborhood",
      colors: colors,
      dataset: %ColumnChart.Dataset{
        axes: %BaseAxes{
          magnitude_axis: %MagnitudeAxis{
            max: 10_000,
            min: 0
          }
        },
        data: Cincy.get()
      }
    }

    progress_chart = progress_chart(from: column_chart)

    {:ok,
     assign(socket,
       column_chart: column_chart,
       progress_chart: progress_chart
     )}
  end

  @impl true
  def handle_info({[:vm, :memory], memory}, socket) do
    {:noreply,
     assign(socket, :progress_chart, Memory.update_chart(socket.assigns.progress_chart, memory))}
  end

  def handle_info(:update_coney_consumption, socket) do
    {:noreply,
     assign(socket, :column_chart, Cincy.update_chart(socket.assigns.column_chart, nil))}
  end

  def handle_info(_, socket), do: {:noreply, socket}

  defp progress_chart(from: %BaseChart{} = chart) do
    memory = Memory.get()

    %BaseChart{
      chart
      | title: "Process Memory / Total",
        colors: %{
          rose_gradient: %Gradient{
            start_color: "#642B73",
            stop_color: "#C6426E"
          },
          blue_gradient: %Gradient{
            start_color: "#36D1DC",
            stop_color: "#5B86E5"
          },
          red_gradient: %Gradient{
            start_color: "#FF9486",
            stop_color: "#FF1379"
          },
          gray: "#e2e2e2"
        },
        dataset: %ProgressChart.Dataset{
          background_stroke_color: :gray,
          label: "Proc Memory",
          secondary_label: "(% Of Total)",
          to_value: memory.total,
          current_value: memory.process,
          percentage_text_fill_color: :blue_gradient,
          percentage_fill_color: :rose_gradient,
          label_fill_color: :rose_gradient
        }
    }
  end
end
