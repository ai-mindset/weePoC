using Genie.Deploy

print("Please wait, buidling Docker container... \n")
Deploy.Docker.build()

print("Running Docker container \n")
Deploy.Docker.run()
