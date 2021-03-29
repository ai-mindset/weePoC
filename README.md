# Expanding my knowledge in Julia

Julia is advertised as a fast, dynamically typed, reproducible, composable (through multiple dispatch), general and open-source programming language. It is gaining traction fast in the Data Science and Scientific Computing communities. Can it be used for writing web apps too? Let's find out 🧐     

My requirements are:   
I want to build a web-service that receives an image and returns the classification of that image.  
Then, I'd like to save the requests and responses from this API to a database.  

First, I'll use [Genie](https://www.genieframework.com/), a well known Julia web framework. And, I'll try to keep everything simple for now.  
For the image recognition part I'll use [VGG19](https://arxiv.org/abs/1409.1556)[^1] as found in [Metalhead.jl](https://github.com/FluxML/Metalhead.jl), a set of Computer Vision models for [Flux.jl](https://github.com/FluxML/Flux.jl).  
For the database part, I will use [SQLite.jl](https://github.com/JuliaDatabases/SQLite.jl), a Julia interface to the SQLite library.  

---

## Usage   

Run `$ ./launch.sh`. This will:  
1. Download Julia [Julia 1.6.0](https://julialang.org/downloads/)   
2. Decompress Julia on Linux or mount the Julia image on macOS (no action for Windows).     

On macOS and Windows, you can launch the app with `julia --project app.jl [port num]` at a [port number](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers) of choice    


---
[^1]: "_Our main contribution is a thorough evaluation of networks of increasing depth using an architecture with very small (3×3) convolution filters, which shows that a significant improvement on the  prior-art configurations can  be  achieved by  pushing the  depth to  16–19 weight layers._"
