# Question
Exercise 1.6.

# Answer
## Codes
```scheme
    (define (xysqrt in)
      (sqrt-iter 1.0 in))
    
    (define (sqrt-iter guess x)
      (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x) x)))
    
    (define (new-if pred if-then if-else)
      (cond (pred if-then)
            (else if-else)))
    
    (define (improve g b)
      (/ (+ g
            (/ b g))
         2.0))
    
    (define (good-enough? c d)
      (< (abs (- (square c)
                 d))
         0.001))
    
    (define (square x)
      (* x x))
```

## Running
```
    1 ]=> (load "1006_b.scm")
    
    ;Loading "1006_b.scm"... done
    ;Value: square
    
    1 ]=> (xysqrt 4)
    
    ;Aborting!: maximum recursion depth exceeded
```

## Analyzing
运行结果：
```
    Aborting!: maximum recursion depth exceeded`
```
提示的程序终止原因是递归深度超过了Scheme的最大限制。

### Recursion depth
#### Test 1
找到了一个测试Scheme recursion depth limit的方法：`recurse`这个方法每次运行时，就显示是第几次执行`recurse`、换行、调用`recurse`，所以通过输出的数字就是`recurse`这个递归方法运行时的递归深度。

##### Codes

    (define (recurse number)
      (begin (display number) (newline) (recurse (+ number 1))))
     

##### Running
输入：
    (recurse 1)

运行结果：

<img src="1006_b_recursion_depth_test.png">

##### Analyzing
在Win7、64位系统、4G内存下执行了近5个小时，递归深度已经达到了1亿多次，但是丝毫没有要停的意思，只有`Abort`了...看来这个测scheme recursion depth的方法不太可行。

#### Test 2
结合Test 1 修改了`xysqrt`，让其每次递归都打印该次递归的深度

##### Codes
    (define (xysqrt in count)
      (sqrt-iter 1.0 in count))
    
    (define (sqrt-iter guess x count)
      (begin (display count) (newline)
             (new-if (good-enough? guess x)
                     guess
                     (sqrt-iter (improve guess x) x (+ count 1)))))

##### Running
输入：
    (xysqrt 4 1)

运行结果：

    1
    18130
    ;Aborting!: maximum recursion depth exceeded

输入：
    (xysqrt 100000000 1)

运行结果：

    1
    18130
    ;Aborting!: maximum recursion depth exceeded

##### Analyzing
说明`xysqrt`在Scheme中的递归深度到了18130就停止了，且跟输入`in`无关。现在似乎已经确定了Scheme中xysqrt运行的最大递归深度，但是结合`Test 1`看，就出现了新的问题，为什么`recurse`没有在这个位置停下来？另外，`xysqrt`的最大递归深度为什么是`18130`？

## `xysqrt` 的递归深度为什么会超过scheme的限制？

    (define (sqrt-iter guess x)
      (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x) x)))

`xysqrt`的递归深度之所以会超过scheme是因为`sysqrt`中使用`new-if`替代系统原有的`if`后，`xysqrt`变成了无限递归。系统原有的`if`是一个special form，根据predicate决定是否递归终止。但是`new-if`是程序员自己创建的compound procedure，采用application order来做替换，于是先计算子表达式，再做替换。但是子表达式中有一项是递归的，这样判断是否需要递归的操作还未执行，就开始执行递归了，于是递归就一直进行下去不能终止，直至超过scheme的递归深度限制。
