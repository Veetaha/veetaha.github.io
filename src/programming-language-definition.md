# Programming Language Definition

Welcome! We are about to find out what programming languages are, and how they work. We are probably eager to start with a code example. To satisfy our whim here is one written in [Rust language][rustlang]:

```rust
fn main() {
  println!("Hello world");
}
```

It is a classic program that prints the words "Hello world" to the terminal window.

We are going to use Rust as our example programming language. However, there may be references and examples written in other languages further.

## Formal vs Natural Language

What we've seen in the code example above is a *formal language* called Rust. We may wonder what the difference between a programming language and a human language like English is. That's a good question.

First of all, we must understand that classic programming languages are text-based. I.e. all code that programmers write is just simple text, and all code editors are text editors as well.

The main feature of programming language is that it is *formal*, which means that it is:
- **Unambiguous** - each word of the language has a singular interpretation within the context where it is written. For example, the computer knows that `println!` instructs it to write to the console, and `"Hello world"` defines what should be printed. The rules of language's syntax, grammar, and semantics fully define what alphabet the language uses, what punctuation, keywords, and other symbols are valid, and in what order. From this follows the next feature.
- **Strict** - the language disallows having grammar mistakes (e.g. a misspelled word or wrong punctuation). If we have any mistakes in our code, we'll see errors when running our program.
- **Little redundancy** - the language is very laconic. It doesn't have redundant constructions that are not necessary for understanding. For example, the word `fn` in the code snippet shown at the beginning stands for "function". The language designers decided to shorten it because it is a widely used keyword that we would like to spend less time typing. Other than that we wouldn't write `The fn main` in a programming language, because articles are usually considered to be a redundancy of a natural language, so we omit `a/an/the` in code to keep it succinct.

## Purpose

Programming languages are mostly used to write applications running on different platforms (servers, PC, Laptops, mobile phones, etc.).

We already know what programs are capable of (web browser, file browser, games, torrent, etc). We can make the computer do almost anything we want, but before we harness the full power we will begin with the basics. Knowing just the basics may make us feel like a child playing in a sandbox, but this groundwork is of the highest importance to building the ground in any language.

## General-Purpose Programming Language Structure

### Direction

Classic programming languages are written in the usual direction just like natural languages. We should read them left-to-right and top-to-bottom. Regular programming languages like Rust, TypeScript, C/C++, C#, Java, Kotlin, Python, etc. share a similar structure.

### Comments

To address an elephant in the room we'll begin with what makes our code readable by letting programmers insert snippets of their natural language (99% of the time the conventional language is English) that explain what happens in the formal language around them. They are called comments, and they are completely ignored by a computer when it runs a program.

Different languages have different syntax for comments, but the most frequent syntax is to use `//` (Rust, C/C++, Java...) or `#` (Python, Ruby, YAML) symbol to denote the beginning of the comment.

The comment doesn't have to start on a new line. Any occurrence of `//` or `#` denotes the beginning of our natural language prattle. Such a comment is called a single-line comment because it finishes only at the end of the line.

```rust
// Blah, bruh, this code is dope, just look at this =)
println!("Hello world");

println!("Twigly"); // Comments can also be written after real code
```

### Whitespace

Most of the languages ignore redundant whitespace. For example, the following 4 programs written in Rust are completely identical in what they do.

```rust
println!("Hello World");
```
```rust
println!( "Hello world"    );
```
```rust
println!( "Hello world"    )
;
```

```rust
println!(

      "Hello world"

                            )

             ;
```

We may recall that formal languages were said to be 'Little redundant'. This "little" is what still allows for exceptional trivial redundancy like this. However, it makes writing code easier and more flexible for humans. In some cases, extra whitespace makes our code prettier.

For example when formatting a long list of things we would like to write it across several lines, disregarding the fact that it would make the text of the program longer.

> Good programmers strive to write their code in a way that it would be easier to read and understand by other people!

E.g. this code is hard to read because it is all on one line.
```rust
let vocabulary = ["Programming", "Rust", "Language", "Niko", "Veetaha", "Dictionary", "List", "Array", "Blackjack", "Morning Glory", "Rampage", "P21", "Project", "Horizons", "Octavia", "Vynil", "University", "Days"];
```

This code is easier to read, even though it takes much more screen space, just because human's perception of smaller lines of text is better than the longer ones.
```rust
let vocabulary = [
  "Programming",
  "Rust",
  "Language",
  "Niko",
  "Veetaha",
  "Dictionary",
  "List",
  "Array",
  // When code is written vertically it's easier to add comments to it
  "Blackjack",
  "Morning Glory",
  "Rampage",
  "P21",
  "Project",
  "Horizons",

  // We can even use whitespace to group related parts of code together visually
  "Octavia",
  "Vynil",
  "University",
  "Days"
];
```

Languages like Python or Ruby give programmers less freedom in how they can use whitespace. However, this way they reduce the number of punctuation symbols in their language (e.g. `;`).

### Expressions

Expressions are parts of the code that evaluate to some value. They are highly composite, and it is very important to understand how expressions compose into an expression tree and how the computer computes them.

#### Literals

The simplest expression is just a *literal* value

```rust
99
```

```rust
"Hello world"
```

```rust
true
```

These values are the atoms of our LEGO. They are called **literals**.

#### Mathematical expressions

Mathematical expressions are the most widely-known kind of expressions:

```rust
2 + 2
```

All expressions like LEGO pieces are composed of smaller LEGO pieces. And this relationship is best described with a tree.

For instance, a computer will build the following expression tree for a simple `2 + 2`.

![][expr-s-1]

The tree is then evaluated from the bottom to the top. Mathematical operators always sit in the middle of the tree and literal values are always at the bottom.

To compute the result of this tree the computer will begin from the bottom and look at the left `2`.

![][expr-s-2]

Since that value is already known (it is *literally* `2` duh...). The computer will look at the right branch of the tree, which is also `2`.

![][expr-s-3]

Then it will conclude that the parameters of the plus (`+`) operator are known, so it can proceed with getting the sum of them, outputting `4` at the end.

![][expr-s-4]

Let's take another example

```rust
(2 + 6) * 9 / 3 > 46 - 1
```

We can see how mathematical expressions can grow in complexity without bounds. What's important is to understand how a computer gets the result of an expression. Our tree representation can scale to this arbitrarily complex math expression. The computer builds the following tree for it:

![][expr-l-1]


We've already seen how the computer copes with a simple `2 + 2`. Similarly, it evaluates `2 + 6` here to `8`:

![][expr-l-2]

We can see that parentheses have a single parameter that they evaluate to directly. From a semantics standpoint, the parentheses operator is used only for grouping parts of the expression tree that have lower operator precedence to give them a higher one. The operator precedence should be known to us from the school (e.g. `*` goes before `+`). So we just replace the parenthesis operator with the value of its argument.

![][expr-l-3]


Then the computer tries to evaluate the right branch of multiplication (`*`), but since that branch is also a nested expression, it follows to evaluate that from the bottom too begging with the literal value `9` that is already known.

![][expr-l-4]

Then it continues with the right branch of that subexpression and experiences the literal value `3` that is also known.

![][expr-l-5]

Likewise, the operator `/` has fully-evaluated values of parameters and the result is substituted with `3`.

![][expr-l-6]

Now we can see where it goes. Operator `*` has fully evaluated values of parameters and the result is substituted with `24`.

![][expr-l-7]

But we are not done yet! The computer must evaluate the right branch of the expression tree. We as humans see that the value is already `46`, but the computer doesn't have eyesight, so it reads whatever is in the right branch to confirm that.

![][expr-l-8]

Now the result of the expression is substituted with the result of a logical comparison operation. `24` is not greater than (`>`) `46`, so `false` is returned.

![][expr-l-9]


#### Arbitrary expressions

As we can see computers work not only with numbers, they work with values of different types including strings, booleans, lists, dictionaries (maps), etc. All of them also have their representation on the expression tree.

For example, suppose we have a dictionary and we would like to get the value of the key `"blackjack"` from it.

```rust
dict["blackjack"]
```

The expression tree for this would be

![][expr-dict-1]

If we want to call a function `print` that would output the value of the dictionary we would do it this way:

```rust
print(dict["blackjack"])
```

resulting in the following expression tree:

![][expr-dict-2]


### Statements

Statements are the next level of LEGO. They consist of expressions.

A statement usually occupies a single line, but it can span multiple lines (except for Python-like languages where they are single-line), and it is delimited with a semicolon (`;`).

```rust
let blackjack = 42;

println!("Hello world");

std::process::exit(0);
```

Statements usually represent the execution of a single command. They are similar to sentences in natural languages.
For example, if we translate the code written in Rust language above to English we would get:

```md
Initialize a variable called blackjack with the integer value 42.

Output the string "Hello world" to the terminal.

Shut down the application with the status code of zero.
```

One difference, as well as the similarity, is that statements have a semicolon at the end, but sentences in English finish with a dot (`.`) or a question mark (`?`) or an exclamation point (`!`).

### Special Kinds of Statements

A semicolon-delimited statement is the most frequent kind of statement we will see in any code. There exist also special kinds of statements that build on top of the regular statement allowing us to compose our program like a LEGO figurine.

There are a bunch of them that can be found in many programming languages:

- Conditional statement (e.g. `if` statement)
- Loop statement (e.g. `while/for` statement)

```rust
if 2 + 2 == 4 {
  println!("Yes that's true!");
}

for counter in 0..5 {
  println!("Counter value: {counter}");
}

while std::io::stdin().lines().next().is_some() {
  println!("You've input a line!");
  println!("Reading your next input...");
}
```

They aren't usually delimited by a semicolon, and they create irregular execution paths (conditional execution, loops).
We can see how they are composed with regular statements. They usually delimit a block of code making the regular statements inside of them be written after a small whitespace gap (indentation). The more statements we embed in them, the more nested our code looks like:

```rust
if 2 + 2 == 4 {
  if 4 + 4 == 8 {
    if 2 * 2 == 4 {
      println!("All checks passed!");
    } else {
      println!("Last check didn't pass...");
    }
  }
}
```

### Variables

Variables are a little bit different in different programming languages. Here are examples of how we would create a variable in different programming languages:

Rust uses the introducer keyword `let` to distinguish between variable declarations and reassignments.
```rust
let variable = "Hello world";
```

Python doesn't use an introducer keyword. This however increases the chance that a programmer creates a variable with a new name instead of reassigning it to the existing variable if they make a typo in the variable name.
```python
variable = "Hello world";

# for example suppose we want to reassign to `variable`
# but we make a typo here `voriable`
voriable = "Equestria"

# This program doesn't work as expected...
print(variable)
```

Java uses an introduce type annotation for the variable
```java
String variable = "Hello world";

// With introducer syntax there is no chance we could make a typo
// This will result in an error when building our application
voriable = "Equestria";
```

We can use variables in place of literal values. Their main purpose is to serve as storage for intermediate calculations as well as to reduce the repetition of literal values in a program.

## Conclusion

These were the most common parts of any language. Once we understand how they work, we will be able to learn any classic programming language with ease, because they differ only in small syntactic peculiarities, which are trivial to study.


## References

- [Формальні і природні мови](https://disted.edu.vn.ua/courses/learn/579)

[rustlang]: https://www.rust-lang.org/

[expr-l-9]: https://user-images.githubusercontent.com/36276403/162851733-9cdc5713-0e6c-4385-8793-165d748e4a9f.jpg
[expr-l-8]: https://user-images.githubusercontent.com/36276403/162851605-f6035cda-258f-4b93-a283-e81ccf314952.jpg
[expr-l-7]: https://user-images.githubusercontent.com/36276403/162851599-f056d9e5-6cff-4fcb-8910-8fa1b8fcd82f.jpg
[expr-l-6]: https://user-images.githubusercontent.com/36276403/162851597-eeabdde1-e366-476c-a7c6-acf59d7b7410.jpg
[expr-l-5]: https://user-images.githubusercontent.com/36276403/162851593-7216e9e9-3511-426d-a103-ca96a00c2616.jpg
[expr-l-4]: https://user-images.githubusercontent.com/36276403/162851359-295160f4-1465-4436-a545-3689edd7f803.jpg
[expr-l-3]: https://user-images.githubusercontent.com/36276403/162851361-a8d0cfc0-4767-4abd-b42d-757f7539708d.jpg
[expr-l-2]: https://user-images.githubusercontent.com/36276403/162851342-e1d8ff5d-d973-4695-8940-dc5f576acf6a.jpg
[expr-l-1]: https://user-images.githubusercontent.com/36276403/162851346-91a5e2a8-df04-443f-956d-ee77d5e24f55.jpg

[expr-s-4]: https://user-images.githubusercontent.com/36276403/162851347-153be3fb-e598-467f-b5bc-959859b2ea56.jpg
[expr-s-3]: https://user-images.githubusercontent.com/36276403/162851348-7fa08aef-4d38-47a6-b76d-617f9c652561.jpg
[expr-s-2]: https://user-images.githubusercontent.com/36276403/162851349-6654bd2d-dc57-4f69-a6f0-2a889fc2be44.jpg
[expr-s-1]: https://user-images.githubusercontent.com/36276403/162851904-e65e6952-94fb-40fc-94f2-dd5372045fed.jpg

[expr-dict-2]: https://user-images.githubusercontent.com/36276403/162854376-76ca0ba2-ddc7-4d45-ba8b-4b873ebadaba.jpg
[expr-dict-1]: https://user-images.githubusercontent.com/36276403/162853769-64176e02-9633-45ac-98a4-aab7936d4cc3.jpg
