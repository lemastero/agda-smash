{-# OPTIONS --without-K --safe #-}

module Data.Can where

open import Level
open import Data.Product using (_,_) renaming (_×_ to _*_)
open import Data.Maybe.Base using (Maybe; just; nothing)
open import Data.Sum renaming
 ( _⊎_ to _+_
 ; swap to s-swap
 ; inj₁ to left
 ; inj₂ to right
 )

private
  variable
    lA lB lP lA' lB' lC : Level
    A  : Set lA
    B  : Set lB
    A' : Set lA'
    B' : Set lB'
    C  : Set lC

data Can (A : Set lA)(B : Set lB) : Set (lA ⊔ lB) where
  non : Can A B
  one : A      -> Can A B
  eno :      B -> Can A B
  two : A -> B -> Can A B

canFst : Can A B -> Maybe A
canFst = {!   !}

canSnd : Can A B -> Maybe B
canSnd = {!   !}

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

bimap : (A -> A') -> (B -> B') -> Can A B -> Can A' B'
bimap f g non = non
bimap f g (one a) = one (f a)
bimap f g (eno b) = eno (g b)
bimap f g (two a b) = two (f a) (g b)

bipure : A -> B -> Can A B
bipure = two

biap : Can (A -> A') (B -> B') -> Can A B -> Can A' B'
biap (one fa) (one a) = one (fa a)
biap (one fa) (two a b) = one (fa a)
biap (eno fb) (eno b) = eno (fb b)
biap (eno fb) (two a b) = eno (fb b)
biap (two fa fb) (two a b) = two (fa a) (fb b)
biap (two fa fb) (one a) = one (fa a)
biap (two fa fb) (eno b) = eno (fb b)
biap _ _ = non

fold : C -> (A -> C) -> (B -> C) -> (A -> B -> C) -> Can A B -> C
fold c _ _ _ non = c
fold c ac _ _ (one a) = ac a
fold c _ bc _ (eno b) = bc b
fold c _ _ abc (two a b) = abc a b

foldWithMerge : C -> (A -> C) -> (B -> C) -> (C -> C -> C) -> Can A B -> C
foldWithMerge c _ _ _ non = c
foldWithMerge c ac _ _ (one a) = ac a
foldWithMerge c _ bc _ (eno b) = bc b
foldWithMerge _ ac bc m (two a b) = m (ac a) (bc b)

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
