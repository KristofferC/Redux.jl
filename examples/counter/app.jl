using Redux
using CImGui

include("Counter.jl")
using .Counter

include("../Renderer.jl")
using .Renderer

const store = create_store(reducer, Counter.State(0))

function counter_ui(store)
    flag = CImGui.ImGuiWindowFlags_NoTitleBar |
           CImGui.ImGuiWindowFlags_NoResize |
           CImGui.ImGuiWindowFlags_AlwaysAutoResize |
           CImGui.ImGuiWindowFlags_NoSavedSettings |
           CImGui.ImGuiWindowFlags_NoFocusOnAppearing |
           CImGui.ImGuiWindowFlags_NoNav
    CImGui.Begin("Counter", Ref(true), flag)
        spacing = CImGui.GetStyle().ItemInnerSpacing.x
        CImGui.PushButtonRepeat(true)
        CImGui.ArrowButton("##left", CImGui.ImGuiDir_Left) && dispatch!(store, Counter.DECREMENT)
        CImGui.SameLine(0.0, spacing)
        CImGui.ArrowButton("##right", CImGui.ImGuiDir_Right) && dispatch!(store, Counter.INCREMENT)
        CImGui.PopButtonRepeat()
        CImGui.SameLine()
        value = Counter.get_counter(get_state(store))
        CImGui.Text("$value")
    CImGui.End()
end

Renderer.render(()->counter_ui(store), width=180, height=180, title="App: Counter")
