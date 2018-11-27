function merge(leftArr, rightArr) {
    var sortedArr = [];
    while (leftArr.length && rightArr.length) {
        if (leftArr[0] <= rightArr[0]) {
            sortedArr.push(leftArr[0]);
            leftArr = leftArr.slice(1)
        } else {
            sortedArr.push(rightArr[0]);
            rightArr = rightArr.slice(1)
        }
    }
    while (leftArr.length)
        sortedArr.push(leftArr.shift());
    while (rightArr.length)
        sortedArr.push(rightArr.shift());
    return sortedArr;
}

function mergesort(arr) {
    if (arr.length < 2) {
        return arr;
    } else {
        var midpoint = parseInt(arr.length / 2);
        var leftArr = arr.slice(0, midpoint);
        var rightArr = arr.slice(midpoint, arr.length);
        return merge(mergesort(leftArr), mergesort(rightArr));
    }
}

function shuffle(array) {
    var currentIndex = array.length,
        temporaryValue, randomIndex;

    // While there remain elements to shuffle...
    while (0 !== currentIndex) {

        // Pick a remaining element...
        randomIndex = Math.floor(Math.random() * currentIndex);
        currentIndex -= 1;

        // And swap it with the current element.
        temporaryValue = array[currentIndex];
        array[currentIndex] = array[randomIndex];
        array[randomIndex] = temporaryValue;
    }

    return array;
}

var arr = [...Array(242881).keys()];
shuffle(arr);
var arr = [...Array(242881).keys()];
shuffle(arr);
var arr = [...Array(242881).keys()];
shuffle(arr);
var arr = [...Array(242881).keys()];
shuffle(arr);
var arr = [...Array(242881).keys()];
shuffle(arr);
var arr = [...Array(242881).keys()];
shuffle(arr);
var arr = [...Array(242881).keys()];
shuffle(arr);
var arr = [...Array(242881).keys()];
shuffle(arr);
var arr = [...Array(242881).keys()];
shuffle(arr);
var arr = [...Array(242881).keys()];
shuffle(arr);