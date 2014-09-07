search = "Terrafractyl:"

leaf = soup.findAll(text=search)[0]

stack = []

try:
    while True:
        if not leaf:
            break;
        leaf = leaf.parent
        stack.append(leaf)
except AttributeError:
    print "DONE"

stack.pop()
stack.pop()

while (True):
    if not stack:
        break
    # go through all content to find out where it lies
    leaf = stack.pop()
    pos = 0
    newLeaf = leaf
    for i in range(0,4000):
        newLeaf = newLeaf.findPreviousSibling()
        pos = i
        if not newLeaf:
            break
    print leaf.name + " at: " + str(pos)