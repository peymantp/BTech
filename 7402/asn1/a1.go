package main

import (
	"encoding/csv"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"unicode"
)

func main() {
	bstr, err := ioutil.ReadFile(os.Args[1])
	file, err := os.Create(os.Args[2] + ".csv")
	writer := csv.NewWriter(file)
	defer file.Close()
	defer writer.Flush()

	if err != nil {
		return
	}
	m := make(map[string]int)
	for _, r := range string(bstr) {
		if unicode.IsLetter(r) {
			s := strings.ToLower(string(r))
			m[s]++
		}
	}
	writer.Write([]string{"Letter", "Occurance"})
	for key, value := range m {
		writer.Write([]string{key, strconv.Itoa(value)})
	}
}
