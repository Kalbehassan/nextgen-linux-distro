import unittest
from pathlib import Path

class TestDistroProfile(unittest.TestCase):
    def test_profile_and_sysctl_stay_aligned(self):
        root = Path(__file__).resolve().parent.parent
        profile = (root / "profiles/diag-appliance.yaml").read_text()
        sysctl = (root / "overlay/etc/sysctl.d/99-hardening.conf").read_text()
        self.assertIn("name: AegisDiagOS", profile)
        self.assertIn("net.ipv4.ip_forward: 0", profile)
        self.assertIn("net.ipv4.ip_forward = 0", sysctl)
        self.assertIn("kernel.randomize_va_space = 2", sysctl)

if __name__ == "__main__": unittest.main()
