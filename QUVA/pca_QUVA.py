import pdb
import os
from numpy import *
#import matplotlib.pyplot as plt

def loadDataSet(filename, delim='\t'):
    fr = open(filename)
    stringArr = [line.strip().split(delim) for line in fr.readlines()]
    datArr = [map(float,line[0].split()) for line in stringArr]
    return mat(datArr)

def pca(dataMat,topNfeat=1000):
    meanVals = mean(dataMat,axis=0)
    meanRemoved = dataMat - meanVals
    covMat = cov(meanRemoved, rowvar=0)
    eigVals,eigVects = linalg.eig(mat(covMat))
    eigValInd = argsort(eigVals)
    eigValInd = eigValInd[:-(topNfeat+1):-1]
    redEigVects = eigVects[:,eigValInd]
    lowDDataMat = meanRemoved*redEigVects
    reconMat = (lowDDataMat*redEigVects.T) + meanVals
    return lowDDataMat,reconMat

path = './temporal-segment-networks/fea_path/QUVA_tsn_fea/QUVA_fusionfea/'
lists = os.listdir(path)
#pdb.set_trace()
for vid in lists:
    filepath = path + vid
    print(filepath)
    Arr = loadDataSet(filepath)
    lowdata, reconMat = pca(Arr,10)
    savepath = './pca_fusion_QUVA/'+vid
    fid = open(savepath,'w')
    for i1 in range(len(lowdata)):
        for j in range(10):
            fid.write(str(float(lowdata[i1,j]))+' ')
        fid.write('\n')
    fid.close()
