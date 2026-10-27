"""Run with python3 -m unittest discover -s tests."""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
FISH = shutil.which("fish")
COLORS = {
    "tide_aws_color": "black",
    "tide_jobs_bg_color": "2a2f37",
    "tide_pwd_bg_color": "263f73",
    "tide_python_bg_color": "2a2f37",
    "tide_status_bg_color_failure": "732632",
}


@unittest.skipUnless(FISH, "fish is required")
class TideColorsTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="fish-tide-colors-")
        self.addCleanup(self.temporary.cleanup)
        self.config = Path(self.temporary.name) / "fish"
        self.config.mkdir()
        for name in ("config.fish", "tide-theme.fish", "tide-theme-dump.fish", "tide-colors.fish"):
            if (ROOT / name).exists():
                shutil.copy(ROOT / name, self.config / name)
        (self.config / "functions").mkdir()
        (self.config / "functions/tide.fish").write_text(
            "function tide\n"
            "    if contains -- --version $argv\n"
            "        echo 'tide, version 7.2.0'\n"
            "    end\n"
            "end\n"
        )
        self.env = dict(os.environ, XDG_CONFIG_HOME=self.temporary.name,
                        PATH="/usr/bin:/bin", COPILOT="1", TERM="dumb")

    def fish(self, script, interactive=False):
        args = [FISH]
        if interactive:
            args.append("--interactive")
        result = subprocess.run(args + ["-c", script], env=self.env,
                                text=True, capture_output=True, timeout=20)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result.stdout

    def assert_colors(self, interactive=True):
        script = "; ".join(f"printf '%s\\n' \"${name}\"" for name in COLORS)
        self.assertEqual(self.fish(script, interactive).splitlines(), list(COLORS.values()))

    def test_startup_applies_colors_and_preserves_layout(self):
        self.fish("set -U tide_left_prompt_items pwd vcs; set -U tide_right_prompt_items time")
        self.assert_colors()
        self.assertEqual(self.fish("echo $tide_left_prompt_items; echo $tide_right_prompt_items",
                                   interactive=True), "pwd vcs\ntime\n")

    def test_next_startup_repairs_reinstall_defaults(self):
        self.assert_colors()
        self.fish("; ".join(f"set -U {name} normal" for name in COLORS))
        self.assert_colors()

    def test_noninteractive_shell_does_not_apply_colors(self):
        self.assertEqual(self.fish("set -qU tide_pwd_bg_color; echo $status"), "1\n")

    def test_missing_tide_does_not_apply_colors(self):
        (self.config / "functions/tide.fish").unlink()
        self.assertEqual(self.fish("set -qU tide_pwd_bg_color; echo $status", interactive=True), "1\n")

    def test_reapplying_colors_does_not_write_unchanged_variables(self):
        self.assert_colors()
        self.assertEqual(self.fish(
            "function color_changed --on-variable tide_pwd_bg_color; echo changed; end; "
            "source \"$__fish_config_dir/tide-colors.fish\"", interactive=True), "")

    def test_dumped_theme_restores_colors_after_local_changes(self):
        self.fish("set -U tide_pwd_bg_color normal; set -U tide_aws_color yellow")
        snapshot = self.fish('source "$__fish_config_dir/tide-theme-dump.fish"')
        for name in COLORS:
            self.assertNotIn(f"set -U {name} ", snapshot)
        (self.config / "dumped-theme.fish").write_text(snapshot)
        self.fish('source "$__fish_config_dir/dumped-theme.fish"')
        self.assert_colors(interactive=False)

    def test_saved_theme_restores_colors(self):
        self.fish('source "$__fish_config_dir/tide-theme.fish"')
        self.assert_colors(interactive=False)

    def test_missing_color_file_does_not_break_startup(self):
        (self.config / "tide-colors.fish").unlink()
        self.assertEqual(self.fish("echo ready", interactive=True), "ready\n")


if __name__ == "__main__":
    unittest.main()
