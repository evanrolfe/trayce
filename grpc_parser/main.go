package main

import (
	"encoding/hex"
	"flag"
	"fmt"
	"log"
	"strings"

	"github.com/jhump/protoreflect/desc"
	"github.com/jhump/protoreflect/desc/protoparse"
	"github.com/jhump/protoreflect/dynamic"
)

// Example:
// go run . -method /api.TrayceAgent/SendContainersObserved -proto /home/evan/Code/grpc_parser/api.proto -message "\x00\x00\x00\x00\x2b\x0a\x29\x0a\x04\x31\x32\x33\x34\x12\x06\x75\x62\x75\x6e\x74\x75\x1a\x0a\x31\x37\x32\x2e\x30\x2e\x31\x2e\x31\x39\x22\x04\x65\x76\x61\x6e\x2a\x07\x72\x75\x6e\x6e\x69\x6e\x67"
//
// Payload (with first five bytes trimmed):
// 00000000  00 00 00 00 2b 0a 29 0a  04 31 32 33 34 12 06 75  |....+.)..1234..u|
// 00000010  62 75 6e 74 75 1a 0a 31  37 32 2e 30 2e 31 2e 31  |buntu..172.0.1.1|
// 00000020  39 22 04 65 76 61 6e 2a  07 72 75 6e 6e 69 6e 67  |9".evan*.running|

func findMethodDescriptor(descriptors []*desc.FileDescriptor, path string) (*desc.MethodDescriptor, error) {
	// Split path into service and method names
	parts := strings.Split(strings.TrimPrefix(path, "/"), "/")
	if len(parts) != 2 {
		return nil, fmt.Errorf("invalid path format. Expected /service/method, got %s", path)
	}
	_, methodName := parts[0], parts[1]

	for _, fd := range descriptors {
		for _, sd := range fd.GetServices() {
			if md := sd.FindMethodByName(methodName); md != nil {
				return md, nil
			}
		}
	}
	return nil, fmt.Errorf("method %s not found", path)
}

func main() {
	var protoFile string
	var methodPath string
	var messageHex string
	var isResponse bool
	flag.StringVar(&protoFile, "proto", "", "Path to the .proto file")
	flag.StringVar(&methodPath, "method", "", "Method path (e.g. /api.TrayceAgent/SendContainersObserved)")
	flag.StringVar(&messageHex, "message", "", "Hex-encoded message (e.g. \\x00\\x00\\x00)")
	flag.BoolVar(&isResponse, "response", false, "Is the message a response?")
	flag.Parse()

	if protoFile == "" || methodPath == "" || messageHex == "" {
		flag.Usage()
		log.Fatal("The -proto, -method, and -message flags are required")
	}

	// Convert hex string to bytes
	msgBytes, err := unescapeHexString(messageHex)
	if err != nil {
		log.Fatalf("Failed to parse message bytes: %v", err)
	}

	// Parse the proto file
	parser := protoparse.Parser{}
	descriptors, err := parser.ParseFiles(protoFile)
	if err != nil {
		log.Fatalf("Failed to parse proto file: %v", err)
	}

	// Find the method descriptor
	methodDesc, err := findMethodDescriptor(descriptors, methodPath)
	if err != nil {
		log.Fatalf("Failed to find method: %v", err)
	}

	// Get the input message descriptor for the method
	var messageDescriptor *desc.MessageDescriptor
	if isResponse {
		messageDescriptor = methodDesc.GetOutputType()
	} else {
		messageDescriptor = methodDesc.GetInputType()
	}

	// Create a dynamic message from the descriptor
	message := dynamic.NewMessage(messageDescriptor)

	err = message.Unmarshal(msgBytes)
	if err != nil {
		log.Fatalf("Failed to unmarshal message: %v", err)
	}

	// Rest of your code...
	msgJson, err := message.MarshalJSON()
	if err != nil {
		log.Fatalf("Failed to marshall message to json: %v", err)
	}
	fmt.Println(string(msgJson))
}

func unescapeHexString(s string) ([]byte, error) {
	// Replace \x with actual hex bytes
	s = strings.ReplaceAll(s, "\\x", "")
	if len(s)%2 != 0 {
		return nil, fmt.Errorf("invalid hex string length")
	}

	return hex.DecodeString(s)
}
