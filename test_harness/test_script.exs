IEx.Helpers.c "config_dist.ex"
IEx.Helpers.c "test_harness.ex"
IEx.Helpers.c "flooding_test.ex"
IEx.Helpers.c "Flooding.ex"
if Node.self == :"coord@arch" do
    for _ <- 1..10, do: TestHarness.test(&FloodingTest.run/2)
    for n <- TestHarness.nodes, do: Node.spawn(n, fn -> System.halt end) 
    System.halt
end
