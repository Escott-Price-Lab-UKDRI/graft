#!/usr/bin/env nextflow
nextflow.enable.dsl=2


/*
QTL MANIFEST MODULE

--

python bin/prepare_qtl_manifest.py \
  --qtls assets/qtls.tsv \
  --qtl_ids fujita_eqtl,eqtlgen_cis \
  --all_cell_types false \
  --cell_type_list Oli \
  --out assets/qtl_manifest/
*/

// CREATE A META QTLS FROM assets file and then pull respective args from it


process GEN_QTL_MANIFEST {
    tag "${meta_qtl.qtl_ids.join('_')}_${meta_qtl.all_cell_types}"

    input:
    tuple val(meta_qtl), path(qtls_file), path(manifest_py)

    output:
    tuple val(meta_qtl), path("qtl_manifest_*.tsv"), emit: manifest

    script:
    """
    set -euo pipefail

    mkdir -p qtl_manifest

    python ${manifest_py} \\
        --qtls ${qtls_file} \\
        --qtl_ids ${meta_qtl.qtl_ids.join(',')} \\
        --all_cell_types ${meta_qtl.all_cell_types} \\
        --cell_type_list ${meta_qtl.cell_type_list.join(',')} \\
        --out .
    """
}