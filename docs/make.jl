using Documenter, MLKernels

makedocs(
    format = :html,
    sitename="MLKernels.jl",
    authors = "Tim Thatcher",
    pages = Any[
        hide("Home" => "index.md"),
        "Interface" => "interface.md",
        "Kernels" => "kernels.md",
        "Kernel Theory" => "kernel-theory.md"
    ]
)