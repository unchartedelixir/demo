defmodule DemoWeb.PageLive do
  @moduledoc false

  use DemoWeb, :live_view

  alias Demo.Examples.Cincy
  alias Demo.SystemData.{Memory, MemoryChart, VMEvents}
  alias Uncharted.{BaseChart, BaseDatum, Gradient}
  alias Uncharted.Axes.{BaseAxes, MagnitudeAxis, PolarAxes, XYAxes}
  alias Uncharted.BarChart
  alias Uncharted.ColumnChart
  alias Uncharted.PieChart
  alias Uncharted.PolarChart
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
        }
      },
      dataset: %PieChart.Dataset{
        data: [
          %BaseDatum{
            name: "Pecan",
            fill_color: :red_gradient,
            values: [20.0]
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
            fill_color: :blue_gradient,
            values: [17.0]
          }
        ]
      }
    }

    polar_chart = %BaseChart{
      title: "Polar Chart",
      colors: colors,
      dataset: %PolarChart.Dataset{
        axes: %PolarAxes{
          r: %MagnitudeAxis{
            max: 20,
            min: 0
          },
          t: %MagnitudeAxis{
            max: 2 * :math.pi,
            min: 0,
            units: :radians
          }
        },
        data: [
          %BaseDatum{
            name: "Point 1",
            values: [1, 0.4 * :math.pi]
          },
          %BaseDatum{
            name: "Point 2",
            values: [5, 1.4 * :math.pi]
          },
          %BaseDatum{
            name: "Point 3",
            values: [12, 0.1 * :math.pi]
          },
          %BaseDatum{
            name: "Point 4",
            values: [4, 0 * :math.pi]
          },
          %BaseDatum{
            name: "Point 5",
            values: [18, 1.9 * :math.pi]
          }
        ]
      }
    }

    line_chart = %BaseChart{
      title: "Live Line Chart",
      colors: colors,
      dataset: %ColumnChart.Dataset{
        axes: %XYAxes{
          x: %MagnitudeAxis{
            max: 700,
            min: 0
          },
          y: %MagnitudeAxis{
            max: 2500,
            min: 0
          }
        },
        data: [
          %BaseDatum{
            name: "Point 1",
            fill_color: :blue_gradient,
            values: [70, 500]
          },
          %BaseDatum{
            name: "Point 2",
            fill_color: :blue_gradient,
            values: [150, 1000]
          },
          %BaseDatum{
            name: "Point 3",
            fill_color: :blue_gradient,
            values: [350, 1600]
          },
          %BaseDatum{
            name: "Point 4",
            fill_color: :blue_gradient,
            values: [450, 1500]
          },
          %BaseDatum{
            name: "Point 5",
            fill_color: :blue_gradient,
            values: [550, 2000]
          }
        ]
      }
    }

    progress_chart = progress_chart(from: column_chart)

    {:ok,
     assign(socket,
       bar_chart: bar_chart(),
       column_chart: column_chart,
       pie_chart: pie_chart,
       polar_chart: polar_chart,
       progress_chart: progress_chart,
       line_chart: line_chart
     )}
  end

  @impl true
  def handle_info({[:vm, :memory], memory}, socket) do
    {:noreply,
     assign(socket, :progress_chart, Memory.update_chart(socket.assigns.progress_chart, memory))}
  end

  def handle_info({[:vm, :system_counts], counts}, socket) do
    {:noreply,
     assign(socket, :bar_chart, MemoryChart.update_chart(socket.assigns.bar_chart, counts))}
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

  defp bar_chart do
    memory_data = MemoryChart.get()

    data = MemoryChart.convert_to_datum(memory_data)

    %BaseChart{
      title: "Live Beam Memory Stats",
      colors: %{
        blue: "#36D1DC",
        rosy_gradient: %Gradient{
          start_color: "#642B73",
          stop_color: "#C6426E"
        }
      },
      dataset: %BarChart.Dataset{
        axes: %BaseAxes{
          magnitude_axis: %MagnitudeAxis{
            max: MemoryChart.chart_max(memory_data),
            min: 0
          }
        },
        data: data
      }
    }
  end
end
