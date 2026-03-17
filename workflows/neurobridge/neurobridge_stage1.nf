#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// inherit processes from modules/
include { QC_GWAS }                    from '../../modules/local/qc_gwas'
include { ADD_NEFF }                   from '../../modules/local/add_neff'
include { LDSC }                       from '../../modules/local/ldsc'
include { SUMHER_RUN }                 from '../../subworkflows/sumher_run'
include { HDL_L }                      from '../../modules/local/hdl_l'
include { LAVA_GWAS_PREP }             from '../../modules/local/lava_prep'
include { MAKE_INFO_FILE }             from '../../modules/local/lava_prep'
include { LAVA }                       from '../../modules/local/lava'
include { CONJFDR_DATA_PREP; CONJFDR } from "../../modules/local/conjFDR"
include { LD_CLUMP }                   from '../../modules/local/ld_clump'
include { DEFINE_LOCI }                from '../../modules/local/def_loci'
include { GWAS_COLOCALISATION }        from '../../modules/local/gwas_coloc'
include { GEN_LD_MATRIX }              from '../../modules/local/ld_matrix'
include { SUSIE_OVERLAP_MAP }          from '../../modules/local/susie'
include { MAGMA }                      from '../../modules/local/magma'
include { FUMA_PREP }                  from '../../modules/local/fuma_prep'
include { FUMA_POST_DIRS }             from '../../modules/local/fuma_post_dirs'
// need MiXeR 
    
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    neurobridge **Stage 1** Workflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Overview:
- Automated pre-gene mapping stage of neurobridge.
- Starts from GWAS input + trait-pair definitions.
- Runs all core upstream cross-trait analyses before the manual FUMA breakpoint.
- Generates harmonised summary statistics, genetic correlation outputs, locus-level prioritisation, fine-mapping results, and FUMA-ready inputs.

Inputs:
- `--input` GWAS samplesheet TSV
- `--pairs` trait-pair TSV
- reference data in `ref/`
- parameters from parameters TSV

Workflow stages:
1) GWAS QC and effective sample size harmonisation.
2) Global genetic architecture analyses (LDSC, SumHer, HDL)
3) Local / locus-level analyses (LAVA, cond/jFDR, locus definition and LD clumping)
4) Downstream prioritisation: (GWAS colocalisation, fine-mapping with SuSiE; gene-level outputs with MAGMA)
5) FUMA pre-processing: (export upload-ready files and create post-FUMA directory skeletons)

Outputs:
- QC outputs
- LDSC / SumHer / HDL-L / LAVA results
- conjFDR outputs
- defined loci
- colocalisation and SuSiE outputs
- MAGMA outputs
- FUMA prep outputs

Note:
- Manual FUMA gene mapping / annotation happens after this stage.
- Stage 2 begins from FUMA-derived mapped genes and annotation outputs.
*/

workflow NEUROBRIDGE_STAGE1 {

    log.info 'Running nf-core/neurobridge: **STAGE 1**'

    if ( !params.input ) {
        error 'You´ve got an issue with assets/gwas.tsv => format it properly!'
    }

    if ( !params.pairs ) {
        error 'You´ve got an issue with assets/ldsc_pairs.tsv => format it properly!'
    }
}