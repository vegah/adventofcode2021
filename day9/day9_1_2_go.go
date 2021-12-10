package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sort"
)

func main() {
	file, err := os.Open("./realdata.txt")
	if err != nil {
		log.Fatal(err)
	}
	content, err := ioutil.ReadAll(file)
	if err != nil {
		log.Fatal(err)
	}

	cavemap := make([]byte, 0)
	checkedmap := make([]byte, 0)
	basins := make([]int, 0)
	width := 0
	for i, s := range content {
		if s != 10 {
			cavemap = append(cavemap, s-48)
			checkedmap = append(checkedmap, 0)
		} else if width == 0 {
			width = i
			fmt.Println("Width of map:", width)
		}
	}

	height := len(cavemap) / width
	part1score := 0

	fmt.Println("Height of map:", height)
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			part1score += int(getpart1score(cavemap, x, y, width, height))
			basins = append(basins, getpart2score(checkedmap, cavemap, x, y, width, height))
		}
	}
	fmt.Println("Part 1 score : ", part1score)
	sort.Ints(basins)
	fmt.Println("Part 2 score : ", basins[len(basins)-1]*basins[len(basins)-2]*basins[len(basins)-3])
}

func getpart2score(checkedmap []byte, cavemap []byte, x int, y int, width int, height int) int {
	if getpart1score(cavemap, x, y, width, height) > 0 {
		basin := getBasinSize(checkedmap, cavemap, x, y, width, height)
		return basin
	}
	return 0
}

func getBasinSize(checkedmap []byte, cavemap []byte, x int, y int, width int, height int) int {
	if getheight(checkedmap, x, y, width, height) == 9 {
		return 0
	}
	setheight(checkedmap, x, y, width, height, 9)
	sum := 0
	current := getheight(cavemap, x, y, width, height)
	if current != 9 {
		sum = sum + 1
		sum = sum + getBasinSize(checkedmap, cavemap, x, y-1, width, height)
		sum = sum + getBasinSize(checkedmap, cavemap, x, y+1, width, height)
		sum = sum + getBasinSize(checkedmap, cavemap, x-1, y, width, height)
		sum = sum + getBasinSize(checkedmap, cavemap, x+1, y, width, height)
	}
	return sum
}

func getpart1score(cavemap []byte, x int, y int, width int, height int) byte {
	top := getheight(cavemap, x, y-1, width, height)
	bottom := getheight(cavemap, x, y+1, width, height)
	left := getheight(cavemap, x-1, y, width, height)
	right := getheight(cavemap, x+1, y, width, height)
	current := getheight(cavemap, x, y, width, height)
	if current < top && current < bottom && current < left && current < right {
		return current + 1
	} else {
		return 0
	}
}

func getheight(cavemap []byte, x int, y int, width int, height int) byte {
	if x < 0 || x >= width || y < 0 || y >= height {
		return 9
	} else {
		return cavemap[x+(y*width)]
	}
}

func setheight(cavemap []byte, x int, y int, width int, height int, value byte) {
	if x >= 0 || x < width || y >= 0 || y < height {
		cavemap[x+(y*width)] = value
	}
}
