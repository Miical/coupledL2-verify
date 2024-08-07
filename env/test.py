import mlvp
from mlvp.triggers import *
from UT_CoupledL2 import DUTCoupledL2
from bundle import TileLinkBundle






async def test_top(dut: DUTCoupledL2):
    mlvp.start_clock(dut)
    tlbundle = TileLinkBundle.from_prefix("master_port_0_0_").bind(dut)


    dut.reset.value = 1
    await ClockCycles(dut, 10)
    dut.reset.value = 0










if __name__ == "__main__":
    mlvp.setup_logging(mlvp.INFO)
    dut = DUTCoupledL2()
    dut.InitClock("clock")

    mlvp.run(test_top(dut))

    dut.Finish()
