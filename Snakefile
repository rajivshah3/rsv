configfile: "config/configfile.yaml"

build_dir = 'results'
auspice_dir = 'auspice'

rule all:
    input:
        expand("auspice/rsv_{subtype}_{build}.json",
               subtype = config.get("subtypes",['a']),
               build = config.get("buildstorun", ['genome'])),
        expand("auspice/rsv_{subtype}_{build}_root-sequence.json",
               subtype = config.get("subtypes",['a']),
               build = config.get("buildstorun", ['genome']))

include: "workflow/snakemake_rules/core.smk"

include: "workflow/snakemake_rules/export.smk"

include: "workflow/snakemake_rules/download.smk"

include: "workflow/snakemake_rules/glycosylation.smk"

include: "workflow/snakemake_rules/clades.smk"


if config.get("deploy_url"):
    include: "workflow/snakemake_rules/nextstrain_automation.smk"

rule clean:
    params:
        targets = ["auspice", "results"]
    shell:
        """
        rm -rf {params.targets}
        """

rule clobber:
    params:
        targets = ["data", "auspice", "results"]
    shell:
        """
        rm -rf {params.targets}
        """
