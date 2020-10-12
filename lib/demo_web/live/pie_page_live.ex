defmodule DemoWeb.PiePageLive do
  @moduledoc false

  use DemoWeb, :live_view

  alias Uncharted.PieChart
  alias Uncharted.{BaseChart, BaseDatum, Gradient}

  @impl true
  def mount(_params, _session, socket) do

    pie_chart = %BaseChart{
      title: "Best Kind of Pie",
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
        green_gradient:  %Gradient{
          start_color: "#1fda00",
          stop_color: "#00e7c4"
        }
      },
      dataset: %PieChart.Dataset{
        data: [
          %BaseDatum{
            name: "Pecan",
            fill_color: :red_gradient,
            values: [20.0],
            emphasize: true
          },
          %BaseDatum{
            name: "Blueberry",
            fill_color: :blue_gradient,
            values: [28.0]
          },
          %BaseDatum{
            name: "Pumpkin",
            fill_color: :rose_gradient,
            values: [35.0]
          },
          %BaseDatum{
            name: "Chocolate",
            fill_color: :green_gradient,
            values: [17.0]
          }
        ]
      }
    }

    {:ok,
     assign(socket,
       pie_chart: pie_chart
     )}
  end

  @impl true

  def handle_info({[:vm, :system_counts], counts}, socket) do
    {:noreply,
     assign(socket, :bar_chart, MemoryChart.update_chart(socket.assigns.bar_chart, counts))}
  end

  def handle_info(_, socket), do: {:noreply, socket}

end
