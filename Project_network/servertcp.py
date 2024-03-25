from socket import *
import time

# Create a TCP
serversock = socket(AF_INET, SOCK_STREAM)

# Bind the socket to the port
server_address = ("localhost", 5566)

serversock.bind(server_address)
print('starting up on {} port {}'.format(*server_address))

# Listen for incoming connections
serversock.listen(1)

# Accept incoming connections and store the client socket and address
client_sock, client_address = serversock.accept()


# Initialize the count of received messages
start_time = time.time()
# Initialize the count of received messages
count = 0

# Continuously receive and count the incoming messages
while True:
    data = client_sock.recv(1024)
    if not data:
        break
    count += 1

# Print the number of received messages
print('received {} messages'.format(count))
end_time = time.time()
# calculate the total time
total_time = end_time - start_time
print('total time required to receive packets: {} seconds'.format(total_time))
# Close the client and server sockets
client_sock.close()
serversock.close()
