
public static class ConvexHull {
  static final int COLINEAR = 0;
  static final int CLOCKWISE = 1;
  static final int COUNTERCLOCKWISE = -1;
  
  static boolean isConvex(ArrayList<PVector> points) {
    ArrayList<PVector> hull = getConvexHull(points);
    if (points.size() != hull.size()) return false;

    int offset = hull.indexOf(points.get(0));
    assert(offset >= 0);
    
    return matchWithOffset(points, hull, offset) || reverseMatchWithOffset(points, hull, offset);
  }

  // Assumes arrays are the same size and that the first element of the
  // first array is at the given offset in the second array.
  private static boolean matchWithOffset(ArrayList<PVector> a, ArrayList<PVector> b, int offset) {
    for (int i = 0; i < a.size(); i++) {
      if (a.get(i) != b.get((offset + i) % b.size())) {
        return false;
      }
    }
    return true;
  }
  // Assumes arrays are the same size and that the first element of the
  // first array is at the given offset in the second array.
  private static boolean reverseMatchWithOffset(ArrayList<PVector> a, ArrayList<PVector> b, int offset) {
    for (int i = 0; i < a.size(); i++) {
      if (a.get(i) != b.get((offset + b.size() - i) % b.size())) {
        return false;
      }
    }
    return true;
  }

  private static ArrayList<PVector> getConvexHull(ArrayList<PVector> points) {
    ArrayList<PVector> result = new ArrayList<PVector>();
    PVector start = getLeftmost(points);
    PVector curr = start;

    do {
      result.add(curr);
      curr = getNextPoint(curr, points);
    } while (start != curr);
    
    return result;
  }

  private static PVector getLeftmost(ArrayList<PVector> points) {
    PVector result = null;
    for (PVector point : points) {
      if (result == null || point.x < result.x) {
        result = point;
      }
    }
    return result;
  }

  private static PVector getNextPoint(PVector curr, ArrayList<PVector> points) {
    PVector result = null;
    for (PVector candidate : points) {
      if (candidate == curr) continue;
      if (result == null || orientation(curr, candidate, result) == COUNTERCLOCKWISE) {
        result = candidate;
      }
    }

    return result;
  }

  // @see http://www.geeksforgeeks.org/convex-hull-set-1-jarviss-algorithm-or-wrapping/
  // To find orientation of ordered triplet (p, q, r).
  // The function returns following values
  //  0 --> p, q and r are colinear
  //  1 --> clockwise
  // -1 --> counterclockwise
  private static int orientation(PVector p, PVector q, PVector r) {
      float val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y);
      if (val == 0) return COLINEAR;
      return val > 0 ? CLOCKWISE : COUNTERCLOCKWISE;
  }
}