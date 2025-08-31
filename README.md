# nixflks

[![Nix Flakes: Test](../../actions/workflows/nix-flakes-test.yml/badge.svg)](../../actions/workflows/nix-flakes-test.yml)

Nix Flakes Collection for DxContainer.

## 📜 Overview

### Available Packages

The following packages are available for use.

<table>
  <thead>
    <tr>
      <th>Package</th>
      <th>Description</th>
      <th>Directory</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <strong><code>bashbrew</code></strong>
      </td>
      <td>Canonical parsing tool for the official Docker images library files.</td>
      <td><code>pkgs/bashbrew</code></td>
    </tr>
    <tr>
      <td>
        <strong><code>s6-cli</code></strong>
      </td>
      <td>A CLI for managing <code>s6-overlay</code> services.</td>
      <td><code>pkgs/s6-cli</code></td>
    </tr>
  </tbody>
</table>

## 🚀 Usage

### Command

<table>
  <thead>
    <tr>
      <th>Package</th>
      <th>Command</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <strong><code>bashbrew</code></strong>
      </td>
      <td><code>nix run github:dxcontainer/nixflks#bashbrew -- --version</code></td>
    </tr>
    <tr>
      <td>
        <strong><code>s6-cli</code></strong>
      </td>
      <td><code>nix run github:dxcontainer/nixflks#s6-cli -- --version</code></td>
    </tr>
  </tbody>
</table>

### Flake Input

To use the packages in your own `flake.nix`, add `nixflks` to your inputs.

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    nixflks = {
      url = "github:dxcontainer/nixflks";
      # Follow the nixpkgs of your project for consistency
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixflks, ... }@inputs: {
    # You can now reference packages like nixflks.packages.<system>.s6-cli
  };
}
```

## 📖 Documentation

Below you will find a list of documentation for tools used in this project.

- **Nix**: Nix Package Manager - [Docs](https://nixos.org)
- **GitHub Actions**: Automation and Execution of Software Development Workflows - [Docs](https://docs.github.com/en/actions)

## 🐛 Found a Bug?

Thank you for your message! Please fill out a [bug report](../../issues/new?assignees=&labels=&template=bug_report.md&title=).

## 📖 License

This project is licensed under the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.txt).