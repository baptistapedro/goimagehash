package main

import (
	"os"
	"github.com/corona10/goimagehash"
	"image/jpeg"
)

func main() {
	file1, _ := os.Open(os.Args[1])
        defer file1.Close()
        img1, _ := jpeg.Decode(file1)
        _, err := goimagehash.AverageHash(img1)
	if err != nil { return }
	return 
}
