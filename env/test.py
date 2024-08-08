import mlvp
import random
from mlvp.triggers import *
from UT_CoupledL2 import DUTCoupledL2
from bundle import TileLinkBundle
from agent import TileLinkAgent

async def test_top(dut: DUTCoupledL2):
    mlvp.start_clock(dut)
    dut.reset.value = 1
    await ClockCycles(dut)
    dut.reset.value = 0

    tlbundle = TileLinkBundle.from_prefix("master_port_0_0_").bind(dut)
    tlbundle.set_all(0)
    tlagent = TileLinkAgent(tlbundle)

    await tlagent.aquire_block(0x100000)
    for _ in range(10):
        send_data = random.randint(0, 2**512)
        await tlagent.release_data(0x100000, send_data)
        ret_data = await tlagent.aquire_block(0x100000)

        print(f"Send Data: {hex(send_data)}\nRet Data: {hex(ret_data)}")
        assert ret_data == send_data


if __name__ == "__main__":
    mlvp.setup_logging(mlvp.INFO)
    dut = DUTCoupledL2()
    dut.InitClock("clock")
    dut.reset.AsImmWrite()

    mlvp.run(test_top(dut))

    dut.Finish()
