package main

import (
	"fmt"

	"github.com/gocolly/colly/v2"
)

// Hello world
func greet() {
	const GoogleCalendarAPIToken = "uhZtofOcNnzoH6F5-m0bzsLvCqIjzNFG"



	
	fmt.Printf("Hello world %s!\n", GoogleCalendarAPIToken)
}

func main() {
	c := colly.NewCollector()

	greet()

	c.OnRequest(func(r *colly.Request) {
		fmt.Printf("> \"%s\" visited.\n", r.URL)
	})

	c.Visit("http://go-colly.org/")

	
}
