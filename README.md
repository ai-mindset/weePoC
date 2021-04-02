# Expanding my knowledge in Julia

Julia is advertised as a fast, dynamically typed, reproducible, composable (through multiple dispatch), general and open-source programming language. It is gaining traction fast in the Data Science and Scientific Computing communities. Can it be used for writing web apps too? Let's find out 🧐     

My requirements are:   
I want to build a web-service that receives an image and returns the classification of that image.  
Then, I'd like to save the requests and responses from this API to a database.  

Libraries used:  
- [Genie](https://www.genieframework.com/), a well known Julia web framework. I'll try to keep everything simple for now.  
- [Metalhead.jl](https://github.com/FluxML/Metalhead.jl), a set of Computer Vision models for [Flux.jl](https://github.com/FluxML/Flux.jl). I'll use VGG19<sup>[1](#vgg)</sup>, since it has better accuracy.  
- [ImageMagick.jl](https://github.com/JuliaIO/ImageMagick.jl) to load images.  
- [SQLite.jl](https://github.com/JuliaDatabases/SQLite.jl) for saving data into a database. 
- [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) for pretty printing tabular data.  

## Usage   

Clone repository `git clone https://github.com/inferential/weePoC`  
Navigate into the directory `cd weePoC`  
Run `$ ./launch.sh`. This will:  
1. Download [Julia 1.6.0](https://julialang.org/downloads/)  
2. Decompress Julia on Linux and WSL (or mount the Julia image on macOS)  
3. Launch app.jl, listen on port 8001 on Linux or WSL (no action for macOS)  
On macOS, you can launch the app with `julia --project src/app.jl [port_num]` at a [port number](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers) of choice.  

To use the app: 
1. Navigate to `localhost:port_num/`  
2. Press `Browse` to select an image (examples are included in `/img`)  
3. Press `Submit` to submit your selection. The classifier will return a label, save it to a database and print a dataframe with the database contents on the browser and on the terminal window.  

Should you wish to stop the server and restart it, press `Ctrl/Cmd-C` and run `./julia-1.6.0/bin/julia --project src/app.jl 8001` where 8001 is a randomly chosen port number.  



Why VGG instead of DenseNet<sup>[2](#dn)</sup> or ResNet<sup>[3](#rn)</sup>, both of which exist in Metalhead.jl?   
![load photo|10%](./img/spacex.jpg)    
When I load this ☝️  SpaceX launcher, here is what different pre-trained convolutional neural networks recognise   
```
julia> img = load("spacex.jpg")  
julia> dn = DenseNet()  
DenseNet()  
julia> classify(dn, img)  
"candle, taper, wax light"  
julia> rn = ResNet()  
ResNet()  
julia> classify(rn, img)  
"tennis ball"  
julia> vgg = VGG()  
VGG()  
julia> classify(vgg, img)  
"missile"  
```


---
<a name="vgg">1</a>: "_[VGG](https://paperswithcode.com/method/vgg) is a classical convolutional neural network architecture. It was based on an analysis of how to increase the depth of such networks. The network utilises small 3 x 3 filters. Otherwise the network is characterized by its simplicity: the only other components being pooling layers and a fully connected layer._"  
 <a name="dn">2</a>: "_A [DenseNet](https://paperswithcode.com/method/densenet) is a type of convolutional neural network that utilises dense connections between layers, through Dense Blocks, where we connect all layers (with matching feature-map sizes) directly with each other. To preserve the feed-forward nature, each layer obtains additional inputs from all preceding layers and passes on its own feature-maps to all subsequent layers._"  
<a name="rn">3</a>: "_[ResNets](https://paperswithcode.com/method/resnet) learn residual functions with reference to the layer inputs, instead of learning unreferenced functions. Instead of hoping each few stacked layers directly fit a desired underlying mapping, residual nets let these layers fit a residual mapping. They stack residual blocks ontop of each other to form network: e.g. a ResNet-50 has fifty layers using these blocks._"  


