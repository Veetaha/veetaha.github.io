# Impl Trait Parameters And Turbofish

## Agenda

We will overview the desugaring of `impl Trait`, how turbofish syntax works and the limitation of using them both together.

If you want to skip to the limitation itself, then go to ["Turbofish Limitation Aftermath"](#turbofish-limitation-aftermath).

> ❗This post covers only `impl Trait` in function parameters position.
>
> `impl Trait` in function return types is a totally different concept, that has almost nothing to do with what's in this article.

## Impl Trait Desugaring

Rust allows you to have a shortcut for defining a function with generic parameters bounded by trait and lifetimes expression.

Here is an example of `impl Trait` usage in function parameter types:

```rust
# trait Trait1 {} trait Trait2 {}
#
fn foo<T>(
    a: impl Trait1,
    b: T,
    c: impl Trait1 + Trait2 + 'static,
    d: impl Trait1,
) {
    /**/
}
```

Under the hood this *probably* desugars into the following code:

> The word *probably* here denotes that it is not the exact desugaring that `rustc` does, which is it's private implementation detail.

```rust
# trait Trait1 {} trait Trait2 {}
#
fn foo<
    T,
    __T1: Trait1,
    __T2: Trait1 + Trait2 + 'static,
    __T3: Trait1
>(
    a: __T1,
    b: T,
    c: __T2,
    d: __T3,
)
{
    /**/
}
```

Here we have a regular generic parameter `T`, and three more generic parameters generated for us by `impl Trait` syntax automatically (`__T1`, `__T2`, `__T3`).

Even if the function uses the same `impl Trait` in several function parameters, they still generate different generic parameter types. That's why even though `a` and `d` have `impl Trait1` type annotation, they still use different `__T1` and `__T3` generic parameters in their desugaring shown above.

The symbols `__T1`, `__T2`, `__T3` are not available in Rust code, therefore there will be limitations when working with them described in the following paragraphs.


## Type Inference And Turbofish Syntax

Let's recap what turbofish (`::<>`) syntax provides to us.
Take an example generic function.

```rust
fn bar<T, U>(a: T, b: U) { /**/ }
```

Suppose we want to provide it with `T = bool` and `U = i32`. We can do this in various ways.

```rust
# fn bar<T, U>(a: T, b: U) { /**/ }
bar             (false, 99); // infer all generic params
bar::<bool, i32>(false, 99); // specify all generic params explicitly with turbofish
bar::<_, _>     (false, 99); // infer 2 generic params
bar::<_, i32>   (false, 99); // infer the first param, but specify the second
bar::<bool, _>  (false, 99); // specify the first param, but infer the second
```

Generic parameters in type definitions and type aliases can use default values. It is not possible to set default values for functions though!

```rust
enum Baz<A, B, C = u32> {
    A(A),
    B(B),
    C(C),
}

// Now we can create the value of the enum as such:

Baz::A::<_, ()>       (false); // (1) Baz<bool, (), u32>
Baz::B::<String, _>   (false); // (2) Baz<String, bool, u32>
Baz::C::<bool, u32, _>(false); // (3) Baz<bool, u32, bool>
```

By omitting the third argument in the turbofish syntax in cases (1) and (2) we opted in to using the default `u32` type for the generic parameter `C`.

When the third generic parameter is overridden, even with a wildcard (`_`), it means that the default value is ignored. The wildcard merely specifies that the generic type parameter has to be inferred from usage.

It means, that the following will produce a compile error.

```rust,compile_fail
# enum Baz<A, B, C = u32> {
#     A(A),
#     B(B),
#     C(C),
# }
#
Baz::C::<bool, u32>(false);
//                  ^^^^^ expected `u32`, found `bool`
```

This is because when using an explicit turbofish syntax **all** required type parameters must be explicitly specified and the optional ones will be set to their default values. Even, if we want to specify only the required type parameters, but infer the rest, we have to use a wildcard `_` to do that.

The same is true even if part of required type parameters can be inferred. For instance, we can't use this syntax to have the value type of the `HashMap` inferred.

```rust,compile_fail
# use std::collections::HashMap;
#
let map = HashMap::<String>::from_iter([
//     |           ^^^^^^^   ------ supplied 1 generic argument
//     |           |
//     |           expected at least 2 generic arguments
    ("key".to_owned(), true)
]);
```

We are forced to enumerate all remaining deduced generic parameters with `_`.
```rust
# use std::collections::HashMap;
#
let map = HashMap::<String, _>::from_iter([("key".to_owned(), true)]);
```


## Turbofish Limitation Aftermath

Based on the knowledge of what `impl Trait` desugars to and how turbofish works, it should be obvious, that `impl Trait` in function parameter type annotations disables the turbofish (`::<>`) call syntax, and requires the generic parameters to be inferred. There is simply no way to specify the values for implicit generic parameters (denoted in previous paragraphs as `__T1`, `__T2`, etc.).

```rust,ignore
# trait Trait1 {}
fn blackjack<T>(a: impl Trait1, b: T, c: impl Trait1) { /**/ }

blackjack::<bool, /* now way to pass two params for impl trait 🤔*/>(/*...*/);
```

The way how the compiler generates implicit generic parameters for each `impl Trait` occurrence is its private implementation detail. It guarantees neither the order nor the position of implicit generic parameters generated from `impl Trait`, so we can't explicitly specify the value for these parameters.

The only way for `rustc` to know what types for each `impl Trait` to use, is via type inference only. This also means we can't specify the value for regular generic parameters other than by letting them be deduced.

For example, it is impossible to call the following function at all.

```rust,compile_fail
# trait Trait1 {}
# impl Trait for i32 {}
fn voldemort<T: Default>(a: impl Trait1) {
    T::default();
}

// No syntax exists to call `voldemort` 😣

voldemort::<bool>(99); // (compile error) can't use turbofish
voldemort(99); // (compile error) can't infer `T` type parameter
```

We are forced to replace all usages of `impl Trait` in function parameters with regular generic types.

```rust
# trait Trait1 {}
# impl Trait1 for i32 {}
fn voldemort<T: Default, U: Trait1>(a: U) {
    T::default();
}

// It's callable, yay 😄!
// But now ugly `_` is required on each call 😖
voldemort::<bool, _>(99);
```

Even if all remaining generic parameters can be trivially inferred we have to enumerate them all with `_`. I recommend never to design such an API that forces users to always write a turbofish *with a bunch of `_` for generic parameters that can be inferred*. Unfortunately, there isn't a better universal workaround for this problem.

There exists [an initiative](https://rust-lang.github.io/impl-trait-initiative/explainer/apit_turbofish.html) to fix this by letting us use turbofish syntax with `impl Trait` parameters being inferred, though I guess it has low priority at the time of this writing 🤔.


### Real World Example

Such a problem occurred for me, when writing an extension trait, but I will depict it as a free function here for simplicity. This function maps one collection into the other.

```rust
fn map_collect<O: FromIterator<T>, I: IntoIterator, T>(
    iter: I,
    map: impl FnMut(I::Item) -> T
) -> O {
    iter.into_iter().map(map).collect()
}
```

Because this function uses `impl Trait` syntax it's impossible to call it with turbofish. For example, we can't instruct `rustc` to infer `Result<Vec<_>>` for the first type parameter that easily.

```rust,compile_fail
# fn map_collect<O: FromIterator<T>, I: IntoIterator, T>(
#     iter: I,
#     map: impl FnMut(I::Item) -> T
# ) -> O {
#     iter.into_iter().map(map).collect()
# }
# use std::io::Error;
// Can't use turbofish to specify that the first type param is `Result<Vec<_>>`
map_collect([false, true], |val| Ok::<bool, Error>(val))?;
//                                                               ^ cannot infer type
# Ok::<(), Error>(())
```

If we add replace `impl FnMut(T::Item) -> T` with the fourth generic parameter we will be able to use turbofish for calling the function, but it will be as ugly as this:
```rust
# fn map_collect<O: FromIterator<T>, I: IntoIterator, T, F: FnMut(I::Item) -> T>(
#     iter: I,
#     map: F
# ) -> O {
#     iter.into_iter().map(map).collect()
# }
# use std::io::Error;
map_collect::<Result<Vec<_>, Error>, _, _, _>([false, true], |val| Ok(val))?;
# Ok::<(), Error>(())
```

# Conclusions

Now you know what the limitations of `impl Trait` are, and how to define a function, that is impossible to call in Rust without [uninhabited types](https://smallcultfollowing.com/babysteps/blog/2018/08/13/never-patterns-exhaustive-matching-and-uninhabited-types-oh-my/).

I hope you learned something new today 😉.

---

[Post on Reddit](https://www.reddit.com/r/rust/comments/w530jw/how_to_define_a_function_you_cant_invoke/)

*2022-07-22*
