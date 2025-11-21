package main

import (
	"flag"
	"fmt"
	"net/http"
	"time"
)

func main() {
	// Optionally listen on a different port
	port := flag.Int("port", 8080, "specify a specific port")
	flag.Parse()

	fmt.Printf("starting http server on port %d", *port)
	hmux := http.DefaultServeMux
	hmux.HandleFunc("/", serveFile)
	httphandler := http.TimeoutHandler(hmux, time.Second*10, "timeout!")

	err := http.ListenAndServe(fmt.Sprintf(":%d", *port), httphandler)
	if err != nil {
		fmt.Println("error starting listener: %w", err)
	}
}

func serveFile(rw http.ResponseWriter, rq *http.Request) {
	rw.Write([]byte(helloWorld()))
}

func helloWorld() string {
 return fmt.Sprintf("greetings! the time is %s", time.Now().Local())
}