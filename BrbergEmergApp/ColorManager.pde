
class ColorManager {
  ColorManager() {}

  public Integer[] getVehicleColors() {
    ArrayList<Integer> colors = new ArrayList<Integer>();
    colors.add(#b82e2e);
    colors.add(#ff9900);
    colors.add(#990099);
    colors.add(#0099c6);
    colors.add(#66aa00);

    Integer[] result = new Integer[colors.size()];
    colors.toArray(result);
    return result;
  }
}
