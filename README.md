# voila-gridstack

[![Join the Gitter Chat](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/QuantStack/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/voila-dashboards/voila-gridstack/stable?urlpath=/voila/tree/examples/scotch_dashboard.ipynb)

A gridstack-based template for [Voilà](https://github.com/voila-dashboards/voila).

## Installation

`voila-gridstack` can be installed with the conda package manager

```
conda install -c conda-forge voila-gridstack
```

or from PyPI

```
pip install voila-gridstack
```

## Format

The template uses metadata defined in the notebook file (`.ipynb`) to configure the layout. 
The specification of the metadata was defined by a now defunct project `jupyter-dashboards`.
The specification is described in `jupyter-dashboards` 
[docs](https://jupyter-dashboards-layout.readthedocs.io/en/latest/metadata.html).

The voila renderer behaves as a "display-only renderer without authoring capabilitiy" as defined in
the specs.  However, there are a few differences compared to the original implmentation:

* if no metadata is found in the notebook voilà will render the notebook as `grid` layout,
* it can not persist the state of the cells (i.e. the re-configuration of the layout will
  be lost, when the user closes the voila page),
* if the cell does not contain view configuration for the particular view type (`grid` or
  `report`) or `hidden` attribute is not defined, voilà will treat it as **visible**.

## Usage

To use the `gridstack` template, pass option `--template=gridstack` to the `voila` command line.

![voila-gridstack](voila-gridstack.gif)

By default the position of cells in the dashboard will be fixed. If you want them to be draggable 
and resizable, you can launch voila with the `show_handles` resource set to `True`:

```
voila --template=gridstack examples/ --VoilaConfiguration.resources='{"gridstack": {"show_handles": True}}'
```

Note, however, that the state of the dashboard can not be persisted in the notebook.

You can change the color scheme using the `theme` resource:

```
voila examples/ --template=gridstack --theme=dark
```

## License

We use a shared copyright model that enables all contributors to maintain the
copyright on their contributions.

This software is licensed under the BSD-3-Clause license. See the
[LICENSE](LICENSE) file for details.
