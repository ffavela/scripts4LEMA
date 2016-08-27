import sys, getopt
import numpy as np

def getRawListFromFile(filename):
    with open(filename,"r") as f:
        lines=f.readlines()
    return lines

def createListJustWithNumbers(numList):
    numberList=[]
    for e in numList:
        newE=e.split()
        if len(newE)<2:
            continue
        intNum=int(newE[0])
        floatPart=[float(v) for v in newE[1:]]
        numberList.append([intNum]+floatPart)
    return numberList
        
def getDict4Average(numList):
    dict4Ave={}
    for e in numList:
        if e[0] not in dict4Ave:
            dict4Ave[e[0]]=[]
        dict4Ave[e[0]].append(e[1:])
    return dict4Ave

def getAvListFromDict(dict4Average):
    avList=[]
    for e in dict4Average:
        theList=np.array(dict4Average[e])
        avList.append([e]+list(theList.mean(0)))
    return avList
        
def printOutAverages(avList):
    for e in avList:
        for ee in e:
            print(ee, end=" ")
        print("")

#Still buggy but since the program will be called from a script no
#worries ;-)
def main(argv):
    iFile=''
    try:
        opts, args = getopt.getopt(argv,"hi:",["iFile="])
    except getopt.GetoptError:
        print('Usage: createAveTxts.py CFile.txt')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('Usage: createAveTxts.py CFile.txt')
            sys.exit()
        elif opt in ("-i","--ifile"):
            iFile=arg
        else:
             print('Usage: createAveTxts.py CFile.txt')
             sys.exit()

    # print("iFile is ", iFile)
    rawLines=getRawListFromFile(iFile)
    numList=createListJustWithNumbers(rawLines)
    dict4Ave=getDict4Average(numList)
    averageList=getAvListFromDict(dict4Ave)
    printOutAverages(averageList)
    

if __name__ == "__main__":
    main(sys.argv[1:])
