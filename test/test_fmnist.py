import fmnist

def test_answer():
    succ = fmnist.train()
    assert succ > 0.80
