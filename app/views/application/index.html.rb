Views::Layouts::Application(
  title: "Home",
  subtitle: "Welcome to PhlexML"
){
  plain "The greeting is #{@greeting}"

  Button { "Click me" }

  main {
    p { "Hello there" }
    ul {
      li { "This is cool" }
    }
  }
}
