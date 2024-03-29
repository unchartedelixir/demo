defmodule DemoWeb.PageLive do
  @moduledoc false

  use DemoWeb, :live_view

  alias Demo.Examples.Cincy
  alias Demo.SystemData.{Memory, MemoryChart, VMEvents}
  alias Uncharted.{BaseChart, BaseDatum, Gradient, Section}
  alias Uncharted.Axes.{BaseAxes, MagnitudeAxis, XYAxes}
  alias Uncharted.{BarChart, ColumnChart, LineChart, PieChart, ProgressChart, ScatterPlot}

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      VMEvents.subscribe()
    end

    colors = %{
      blue: "#6bdee4",
      line_blue: "#ddeff9",
      dark_gradient: %Gradient{
        start_color: "#02215a",
        stop_color: "#053b9e"
      },
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
            min: 0,
            line_color: :line_blue
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

    line_chart = %BaseChart{
      title: "Live Line Chart",
      colors: colors,
      dataset: %LineChart.Dataset{
        axes: %XYAxes{
          x: %MagnitudeAxis{
            max: 700,
            min: 0,
            line_color: :line_blue
          },
          y: %MagnitudeAxis{
            max: 2500,
            min: 0,
            line_color: :line_blue
          }
        },
        data: [
          %BaseDatum{
            name: "Point 1",
            fill_color: :dark_gradient,
            values: [0, 500]
          },
          %BaseDatum{
            name: "Point 2",
            fill_color: :dark_gradient,
            values: [140, 1000]
          },
          %BaseDatum{
            name: "Point 3",
            fill_color: :dark_gradient,
            values: [280, 1600]
          },
          %BaseDatum{
            name: "Point 4",
            fill_color: :dark_gradient,
            values: [420, 1500]
          },
          %BaseDatum{
            name: "Point 5",
            fill_color: :dark_gradient,
            values: [560, 2000]
          },
          %BaseDatum{
            name: "Point 6",
            fill_color: :dark_gradient,
            values: [700, 2400]
          }
        ]
      }
    }

    progress_chart = progress_chart(from: column_chart)

    scatter_plot = %BaseChart{
      title: "Live Scatter Plot",
      colors: colors,
      dataset: %ScatterPlot.Dataset{
        axes: %XYAxes{
          x: %MagnitudeAxis{
            max: 5,
            min: 0,
            line_color: :line_blue
          },
          y: %MagnitudeAxis{
            max: 2500,
            min: 0,
            line_color: :line_blue
          }
        },
        data: [
          %BaseDatum{
            name: "Point 1",
            fill_color: :red_gradient,
            values: [0, 2500]
          },
          %BaseDatum{
            name: "Point 2",
            fill_color: :blue_gradient,
            values: [1.2, 1800]
          },
          %BaseDatum{
            name: "Point 3",
            fill_color: :rose_gradient,
            values: [1.9, 2000, 30]
          },
          %BaseDatum{
            name: "Point 4",
            fill_color: :red_gradient,
            values: [2.7, 1400, 10]
          },
          %BaseDatum{
            name: "Point 5",
            fill_color: :blue_gradient,
            values: [3.5, 1800, 60]
          },
          %BaseDatum{
            name: "Point 6",
            fill_color: :rose_gradient,
            values: [4.2, 1800, 50]
          }
        ]
      }
    }

    stacked_column_chart = %BaseChart{
      title: "Cheese Coney Consumption by Neighborhood",
      component_id: "stacked column chart",
      colors: colors,
      component_id: "stacked_chart",
      dataset: %ColumnChart.Dataset{
        axes: %BaseAxes{
          magnitude_axis: %MagnitudeAxis{
            max: 10_000,
            min: 0
          }
        },
        sections: [
          %Section{fill_color: :rose_gradient, label: "June", index: 1},
          %Section{fill_color: :red_gradient, label: "July", index: 2},
          %Section{fill_color: :blue_gradient, label: "May", index: 0}
        ],
        data:
          ~w(Landen Oakley Downtown Florence Erlanger)
          |> Enum.map(fn neighborhood ->
            %BaseDatum{
              name: neighborhood,
              values: [:rand.uniform() * 4_000, :rand.uniform() * 3_000, :rand.uniform() * 3_000]
            }
          end)
      }
    }

    {:ok,
     assign(socket,
       bar_chart: bar_chart(),
       column_chart: column_chart,
       pie_chart: pie_chart,
       progress_chart: progress_chart,
       line_chart: line_chart,
       scatter_plot: scatter_plot,
       stacked_column_chart: stacked_column_chart
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
          dark_gradient: %Gradient{
            start_color: "#02215a",
            stop_color: "#053b9e"
          },
          blue_gradient: %Gradient{
            start_color: "#36D1DC",
            stop_color: "#5B86E5"
          },
          red_gradient: %Gradient{
            start_color: "#FF9486",
            stop_color: "#FF1379"
          },
          gray: "#ddeff9",
          blue: "#02215a"
        },
        dataset: %ProgressChart.Dataset{
          background_stroke_color: :gray,
          doughnut_width: "3px",
          label: "Proc Memory",
          secondary_label: "(% Of Total)",
          to_value: memory.total,
          current_value: memory.process,
          percentage_text_fill_color: :blue_gradient,
          percentage_fill_color: :dark_gradient,
          label_fill_color: :blue
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
        line_blue: "#ddeff9",
        rosy_gradient: %Gradient{
          start_color: "#642B73",
          stop_color: "#C6426E"
        }
      },
      dataset: %BarChart.Dataset{
        axes: %BaseAxes{
          magnitude_axis: %MagnitudeAxis{
            max: MemoryChart.chart_max(memory_data),
            min: 0,
            line_color: :line_blue
          }
        },
        data: data
      }
    }
  end
end
