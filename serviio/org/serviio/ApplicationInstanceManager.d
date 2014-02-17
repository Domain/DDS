

java.io.BufferedReader
java.io.IOException
java.io.InputStreamReader
java.io.OutputStream
java.net.InetAddress
java.net.ServerSocket
java.net.Socket
java.net.UnknownHostException
org.slf4j.Logger
org.slf4j.LoggerFactory

ApplicationInstanceManager

  log = getLogger
  subListener
  SINGLE_INSTANCE_NETWORK_SOCKET = 44331
  SINGLE_INSTANCE_SHARED_KEY = "$$NewInstance$$\n"
  CLOSE_INSTANCE_SHARED_KEY = "$$CloseInstance$$\n"
  socket
  
  registerInstance
  
     = 
    
    
      socket = 44331, 10, getLocalHost()
      logdebug"Listening for application instances on socket 44331"
       = ()
      
        run
        
           = 
           ( {
             (socketisClosed() {
               = 
             {
              
              
                 = socketaccept()
                 = getInputStream()
                 = readLine()
                 ("$$NewInstance$$\n"trim()equalstrim()
                
                  logdebug"Shared key matched - new application instance found"
                  fireNewInstance
                
                 ("$$CloseInstance$$\n"trim()equalstrim()
                
                  logdebug"Close key matched - close request found"
                  fireNewInstance
                
                close()
                close()
              
               (
              
                 = 
              
            
          
        
      , "Instance checker"
      




      setDaemon
      start()
    
     (
    
      logerrorgetMessage(), 
      
    
     (
    
      
      
         = getLocalHost(), 44331
         = getOutputStream()
         (
        
          logdebug"Notifying first instance to stop."
          write"$$CloseInstance$$\n"getBytes()
        
        
        
          logdebug"Port is already taken. Notifying first instance."
          write"$$NewInstance$$\n"getBytes()
        
        close()
        close()
        logdebug"Successfully notified first instance."
        
      
       (
      
        logerrorgetMessage(), 
        
      
       (
      
        logerror"Error connecting to local port for single instance notification"
        logerrorgetMessage(), 
        
      
    
    
  
  
  stopInstance
  
    
    
       (socket!= {
        socketclose()
      
    
     ( {}
  
  
  setApplicationInstanceListener
  
    subListener = 
  
  
  fireNewInstance
  
     (subListener!= {
      subListenernewInstanceCreated
    
  



/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ApplicationInstanceManager
 * JD-Core Version:    0.7.0.1
 */