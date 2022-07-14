defmodule DebugOMatic.Scene.Home do
  use Scenic.Scene
  import Scenic.Primitives
  # import Scenic.Components

  require Logger

  alias Scenic.Graph
  alias Scenic.Scene

  # --------------------------------------------------------
  @impl Scene
  def init(%{viewport: %{size: size}} = init_scene, _param, _opts) do
    Scene.capture_input(init_scene, [:key])

    graph =
      Graph.build()
      |> rect(size, t: {0, 0}, input: [:cursor_pos], id: :viewport_rect)
      |> group(
        fn g ->
          g
          |> line({{0, 0}, {0, 0}}, stroke: {1, :black}, id: :cursor_x_target)
          |> line({{0, 0}, {0, 0}}, stroke: {1, :black}, id: :cursor_y_target)
        end,
        id: :cursor_target
      )

    scene =
      init_scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:ok, scene}
  end

  @impl Scene
  # Cursor target
  def handle_input(
        {:cursor_pos, {cursor_x, cursor_y}},
        :viewport_rect,
        %{viewport: %{size: {viewport_x, viewport_y}}, assigns: %{graph: graph}} = scene
      ) do
    trunc_cursor_x = trunc(cursor_x)
    trunc_cursor_y = trunc(cursor_y)

    graph =
      graph
      |> Graph.modify(
        :cursor_x_target,
        fn i -> line(i, {{trunc_cursor_x, 0}, {trunc_cursor_x, viewport_x}}) end
      )
      |> Graph.modify(
        :cursor_y_target,
        fn i -> line(i, {{0, trunc_cursor_y}, {viewport_y, trunc_cursor_y}}) end
      )

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:noreply, scene}
  end

  # Enable grid
  def handle_input(
        {:key, {:key_g, 1, _}},
        _,
        %{viewport: %{size: viewport_size}, assigns: %{graph: graph}} = scene
      ) do
    spec = %{size: 5, stroke: 1, fill: :black, padding: 10}
    specs = LayoutOMatic.PrimitiveLayout.grid_auto_layout(viewport_size, spec)

    graph = add_specs_to_graph(graph, specs)

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:noreply, scene}
  end

  def handle_input(event, id, scene) do
    Logger.debug("Unexpected event: #{inspect(event)} for id: #{inspect(id)}")
    {:noreply, scene}
  end
end
