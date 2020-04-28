IEx.Helpers.c "config_local.ex"
IEx.Helpers.c "test_harness.ex"
IEx.Helpers.c "flooding_test.ex"
IEx.Helpers.c "Flooding.ex"

IO.puts(Node.self)

if Node.self == :"coord@arch" do
    for _ <- 1..10, do: TestHarness.test(&FloodingTest.run/2)
end
System.halt
