package main

import (
	"fmt"
	"regexp"
	"testing"
)

func TestServe(t *testing.T) {
	want := "hello world"
	got := helloWorld()
	match, _ := regexp.MatchString(fmt.Sprintf("%s.*",want), got)

	if !match {
		t.Errorf("got %q want %q", got, want)
	}
}