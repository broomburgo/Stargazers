
precedencegroup RightCompositionPrecedence {
    associativity: right
}

infix operator <| : RightCompositionPrecedence

func <| <A,B> (lhs: (A) -> B, rhs: A) -> B {
    return lhs(rhs)
}

precedencegroup LeftCompositionPrecedence {
    associativity: left
    higherThan: RightCompositionPrecedence
}

infix operator |> : LeftCompositionPrecedence

func |> <A,B> (lhs: A, rhs: (A) -> B) -> B {
    return rhs(lhs)
}
