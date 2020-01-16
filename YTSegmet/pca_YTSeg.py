import pdb
import os
from numpy import *
#import matplotlib.pyplot as plt

def loadDataSet(filename,delim='\t'):
    fr = open(filename)
    stringArr = [line.strip().split(delim) for line in fr.readlines()]
    datArr = [map(float,line[0].split()) for line in stringArr]
    return mat(datArr)

def pca(dataMat,topNfeat=1000):
    meanVals = mean(dataMat,axis=0)
    meanRemoved = dataMat - meanVals
    covMat = cov(meanRemoved, rowvar=1)
    print('Shape of covMat:', covMat.shape)
    eigVals,eigVects = linalg.eig(mat(covMat))
    eigValInd = argsort(eigVals)
    eigValInd = eigValInd[:-(topNfeat+1):-1]
    redEigVects = eigVects[:,eigValInd]
    lowDDataMat = meanRemoved*redEigVects
    reconMat = (lowDDataMat*redEigVects.T) + meanVals
    return lowDDataMat,reconMat

rgb_path = './temporal-segment-networks/fea_path/YTseg_tsn_fea/YT_seg_rgb_fea/'
#flow_path = './temporal-segment-networks/fea_path/YTseg_tsn_fea/YT_seg_flow_fea/'
#path = '../C3D/C3D-v1.0/examples/c3d_feature_extraction/output/YT_seg_c3d/fea_txt/'
length = len(os.listdir(rgb_path))

for i in range(length):
    filepath = rgb_path + 'YT_seg_{0:02}.txt'.format(i)
    Arr = loadDataSet(filepath)
    lowdata, reconMat = pca(Arr,10)
    savepath = './pca_dyh_row/rowcov/'+'{0:02}.txt'.format(i+1)
    fid = open(savepath,'w')
    for i1 in range(len(lowdata)):
        for j in range(10):
            fid.write(str(float(lowdata[i1,j]))+' ')
        fid.write('\n')
    fid.close()
