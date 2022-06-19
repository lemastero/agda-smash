{-# OPTIONS --without-K --safe #-}

module Data.Can where

open import Level
open import Data.Product using (_,_) renaming (_×_ to _*_)
open import Data.Sum renaming
 ( _⊎_ to _+_
 ; swap to s-swap
 ; inj₁ to left
 ; inj₂ to right
 )

private
  variable
    lA lB lP : Level
    A : Set lA
    B : Set lB

data Can (A : Set lA)(B : Set lB) : Set (lA ⊔ lB) where
  non : Can A B
  one : (a : A)            -> Can A B
  eno : (b : B)            -> Can A B
  two : (a : A) -> (b : B) -> Can A B

fromProduct : A * B -> Can A B
fromProduct (a , b) = two a b

fromSum : A + B -> Can A B
fromSum (left a) = one a
fromSum (right b) = eno b

swap : Can A B -> Can B A
swap non = non
swap (one a) = eno a
swap (eno b) = one b
swap (two a b) = two b a

Can-Induction : {A : Set lA} {B : Set lB} (P : Can A B -> Set lP)
  -> P non
  -> ((a : A) -> P (one a))
  -> ((b : B) -> P (eno b))
  -> ((a : A) -> (b : B) -> P (two a b))
  -> (s : Can A B) -> P s
Can-Induction P pn po pe pt non = pn
Can-Induction P pn po pe pt (one a) = po a
Can-Induction P pn po pe pt (eno b) = pe b
Can-Induction P pn po pe pt (two a b) = pt a b
