{%- extends 'gridstack_base.tpl' -%}

{% block html_head_css %}
{{ super() }}

<style>
.config {
    position: absolute;
    top: 0;
    right: 0;
    z-index: 1000;
}

.config .openConfig {
    text-align: right;
}

.config .openConfig i {
    margin: 4px;
    cursor: pointer;
}

#gsConfig {
    background-color: white;
    font-size: 11px;
    border: 1px solid black;
    padding-left: 8px;
    padding-right: 8px;
}

#gsConfig .output {
    background-color: #EDEDED;
    margin-top: 4px;
    margin-bottom: 4px;
    padding: 8px;
}

.config pre {
    font-size: 11px;
    margin-top: 4px;
    margin-bottom: 4px;
}
</style>
{% endblock html_head_css %}

{% block html_head_js scoped %}
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.0/jquery-ui.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/3.5.0/lodash.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/gridstack@0.5.2/dist/gridstack.all.js"></script>
<script src="https://cdn.jsdelivr.net/npm/gridstack@0.5.2/dist/gridstack.jQueryUI.min.js"></script>
<script type="text/javascript">
    // bqplot doesn't resize when resizing the tile, fix: fake a resize event
    var resize_workaround = _.debounce(() => {
        window.dispatchEvent(new Event('resize'));
    }, 100)
    $(function () {
        $('.grid-stack').gridstack({
            alwaysShowResizeHandle: /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent),
            {% if resources.gridstack.show_handles %}
            resizable: {
                handles: 'e, se, s, sw, w'
            },
            {% else %}
            resizable: {
                handles: 'none'
            },
            {% endif %} 
            {% if gridstack_conf.defaultCellHeight %}
            cellHeight: {{gridstack_conf.defaultCellHeight}}, 
            {% endif %}
            {% if gridstack_conf.maxColumns %}
            width: {{gridstack_conf.maxColumns}}, 
            {% endif %}
            {% if gridstack_conf.cellMargin is defined %}
            verticalMargin: {{gridstack_conf.cellMargin}},
            {% endif %}
            draggable: {
                handle: '.gridhandle',
            }
        }).on('resizestop', function(event, elem) {
            resize_workaround()
        }).on('change', updateConfig);

        updateConfig();
        setCellNrs();
    });
</script>
<script type="text/javascript">
    function updateConfig() {
        const gsConfig = document.getElementById('gsConfig');
        const cells = []
        const items = document.querySelectorAll('.grid-stack-item');

        items.forEach(item => {
            cells.push({
                width: parseInt(item.dataset.gsWidth),
                height: parseInt(item.dataset.gsHeight),
                col: parseInt(item.dataset.gsX),
                row: parseInt(item.dataset.gsY),
            });
        });

        gsConfig.innerHTML = cells.map((cell, index) =>
            `<div class="output">
                Output ${index + 1}
                <pre>${JSON.stringify(cell, null, 2)}</pre>
            </div>`
        ).join('');
    }

    let open = false;

    function showConfig() {
        open = !open

        const gsConfig = document.getElementById('gsConfig');
        gsConfig.style.visibility = open ? 'visible' : 'hidden';
    }

    function setCellNrs() {
        let count = 1;
        const items = document.querySelectorAll('.cell_output');
        items.forEach(item => {
            item.innerHTML = 'Output ' + count;
            count++;
        });
    }
</script>
{{ super() }}
{% endblock html_head_js %}


{% block any_cell scoped %}
    {% set cell_jupyter_dashboards = cell.metadata.get('extensions', {}).get('jupyter_dashboards', {}) %}
    {% set view_data = cell_jupyter_dashboards.get('views', {}).get(active_view, {}) %}
    {% set hidden = view_data.get('hidden') %}
    {% set auto_position = ('row' not in view_data or 'col' not in view_data) %}
    {%- if not hidden and cell.cell_type in ['markdown', 'code'] %}
    <div class="grid-stack-item"
         data-gs-width="{{ view_data.width | default(12) }}"
         data-gs-height="{{ view_data.height | default(2) }}"
         {% if auto_position %}
         data-gs-auto-position=true
         {% else %}
         data-gs-y="{{ view_data.row }}"
         data-gs-x="{{ view_data.col }}"
         {% endif %}
         >
        <div class="grid-stack-item-content">
            {% if resources.gridstack.show_handles %}
            <div class="gridhandle">
                <i class=" fa fa-arrows"></i>
                <span class="cell_output"></span>
            </div>
            {% endif %}
            {{ super() }}
        </div>
    </div>
    {% endif %}
{% endblock any_cell %}

{% block body %}
<section id="demo" class="voila-gridstack">
    <div class="container">
        <div class="grid-stack" data-gs-animate="yes">
                {{ super() }}
        </div>
    </div>
</section>

{% if resources.gridstack.show_handles %}
<div class="config">
    <div class="openConfig">
        <i class="fa fa-cog"  onclick="showConfig()"></i>
    </div>
    <div id="gsConfig" style="visibility: hidden">
    </div>
</div>
{% endif %}
{% endblock body %}
