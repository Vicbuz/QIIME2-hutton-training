# -*- coding: utf-8 -*-
"""
Created on Thu Jun 20 09:01:39 2024

@author: Vic Buswell

script to merge taxon 
"""
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 18 08:50:21 2023

@author: Victoria Buswell

Reformats the outputs I pulled from Qiime2 and formats to combine taxon and sequences with the OTU out table.
"""

import pandas as pd
import sys

def taxon_feature_merge(feature_table, rep_seq_taxa, outfile):
    feature_table =pd.read_csv(feature_table,
                           sep='\t',
                           skiprows=1)
    #print(feature_table)
    taxonomy_table =pd.read_csv(rep_seq_taxa,
                                sep='\t')
    #print(taxonomy_table)
    taxonomy_table = taxonomy_table.drop(0, axis=0)
    merge = feature_table.merge(taxonomy_table,
                                left_on="#OTU ID",
                                right_on="id")

    merge.insert(1, 'Sequence', merge.pop('Sequence'))
    merge.insert(2, 'Taxon', merge.pop('Taxon'))
    merge.insert(1, 'id', merge.pop('id'))
    merge.drop(['id'], axis=1, inplace=True)
    merge.to_csv(outfile,
                  sep='\t',
                  index=False)
        

feature_table=str(sys.argv[1])
rep_seq_taxa=str(sys.argv[2])
outfile=str(sys.argv[3])
taxon_feature_merge(feature_table, rep_seq_taxa, outfile)
