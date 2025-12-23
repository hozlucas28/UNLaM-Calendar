package main

import (
	"fmt"

	"github.com/gocolly/colly"
)

func main() {
	c := colly.NewCollector()

	c.OnRequest(func(r *colly.Request) {
		fmt.Printf("> \"%s\" visited.\n", r.URL)
	})

	c.Visit("http://go-colly.org/")
}
