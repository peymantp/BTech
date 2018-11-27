var fib = function fibonacci(num) {
  var a = 1,
    b = 0,
    temp;

  while (num >= 0) {
    temp = a;
    a = a + b;
    b = temp;
    num--;
  }

  return b;
}

fib(94);
fib(94);
fib(94);
fib(94);
fib(94);
fib(94);
fib(94);
fib(94);
fib(94);
fib(94);
fib(94);
//console.log(fib(94));