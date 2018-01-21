import Foundation

precedencegroup ApplicationPrecedence {
    associativity: left
    lowerThan: NilCoalescingPrecedence
}

infix operator <| : ApplicationPrecedence

func <| <A,B> (lhs: (A) -> B, rhs: A) -> B {
    return lhs(rhs)
}

infix operator |> : ApplicationPrecedence

func |> <A,B> (lhs: A, rhs: (A) -> B) -> B {
    return rhs(lhs)
}
