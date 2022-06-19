{-# OPTIONS --without-K --safe #-}

module Data.Wedge where

open import Level
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
    P : Set lP

data Wedge {lA lB} (A : Set lA)(B : Set lB) : Set (lA ⊔ lB) where
  nowhere : Wedge A B
  here : (a : A) -> Wedge A B
  there : (b : B) -> Wedge A B

Wedge-induction : {A : Set lA} {B : Set lB} (P : Wedge A B -> Set lP)
 -> P nowhere
 -> ((a : A) -> P (here a))
 -> ((b : B) -> P (there b))
 -> (w : Wedge A B) -> P w
Wedge-induction P pn _ _ nowhere = pn
Wedge-induction P _ ph _ (here a) = ph a
Wedge-induction P _ _ pt (there b) = pt b

fromSum : A + B -> Wedge A B
fromSum (left a) = here a
fromSum (right b) = there b

swap : Wedge A B -> Wedge B A
swap nowhere = nowhere
swap (here a) = there a
swap (there b) = here b
